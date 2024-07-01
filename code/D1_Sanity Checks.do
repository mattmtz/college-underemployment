/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: SANITY CHECK
*** DATE:    07/01/2024
********************************/

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
