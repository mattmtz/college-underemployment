/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: SANITY CHECK
*** DATE:    07/01/2024
********************************/

************************************
*** CHECK UNDEREMPLOYMENT SHARES ***
************************************

use "../intermediate/underemployment_data", clear

** KEEP AGE CATEGORY OF INTEREST **
keep if agedum_25_54 == 1
drop agedum*

** CALCULATE COMPARISON WAGES BY OCC **
preserve
	keep if agg_educ_lvl == "bls_educ"
	collapse (p50) comp_wage = incwage [pw = perwt], by(bls_occ occ_soc)
	tempfile MEDWAGE
	save `MEDWAGE'
restore

merge m:1 bls_occ occ_soc using `MEDWAGE'
	assert _merge == 1 if educ_req_nbr == 3.5
	drop _merge

** CALCULATE BA OVEREDUC BY DEFINITION **
keep if cln_educ_cat == "bachelors"

gen overeduc_bls = 0
	replace overeduc_bls = perwt if educ_req_nbr < 5

gen overeduc_gucew = 0
	replace overeduc_gucew = perwt if inlist(educ_req_nbr, 1, 3, 3.5)
	replace overeduc_gucew = perwt if educ_req_nbr == 2 & ///
	 incwage <= $BA_PREM1 * comp_wage
	replace overeduc_gucew = perwt if educ_req_nbr == 4 & ///
	 incwage <= $BA_PREM2 * comp_wage

** COLLAPSE DATA **
gen n = 1
collapse (sum) n_raw = n n_wtd = perwt overeduc_bls overeduc_gucew, by(bls_occ educ_req)
drop if n_raw < $NFLAG

** CALCULATE SHARES **
collapse (sum) n_wtd overeduc*

gen bls = overeduc_bls / n_wtd
gen gucew = overeduc_gu / n_wtd
bro

*************************************************
*** CHECK DEMING 2023 OCCUPATIONAL CATEGORIES ***
*************************************************

** PREPARE DEMING XWALK **
import excel using "input/Deming_2017_TableA3.xlsx", sheet("Table A3") first clear
keep occ code_desc acs_2010
drop if mi(acs)

replace occ1990 = occ[_n-1] if mi(occ)
replace code = code[_n-1] if mi(code)

* See FN 24 of Deming (2023) "Why do Wages Grow Faster for Educated Workers?"
gen deming_cat = ""
	replace deming_cat = "other_professional" if occ > 22 & occ < 236
	replace deming_cat = "sales_admin_support" if occ > 242 & occ < 400
	replace deming_cat = "blue_collar" if occ >= 400
	replace deming_cat = "management" if occ > 3 & occ < 23
	replace deming_cat = "management" if inlist(occ, 243, 303, 413, 414, 415) | inlist(occ, 433, 448, 450, 470, 503, 558, 628, 803, 823)

rename acs occ2010
keep occ2010 deming_cat
duplicates drop

tempfile DEMING
save `DEMING'

** MERGE INTO DATASET **
use "../intermediate/underemployment_data", clear
	keep if agedum_25_54 == 1
	drop agedum*
	
merge m:1 occ2010 using `DEMING'

tab _merge // 89.38% of obs matched
keep if _merge == 3

** COLLAPSE DATA **
preserve
	collapse (sum) perwt, by(educ_req cln_educ_cat deming)
	tempfile COUNTS
	save `COUNTS'
restore

collapse (p50) incwage [pw = perwt], by(educ_req cln_educ_cat deming)
	merge 1:1 educ_req cln_educ deming using `COUNTS', nogen
	
keep if strpos(educ_req, "High school") & inlist(cln_educ_cat, "hs", "bachelors")
