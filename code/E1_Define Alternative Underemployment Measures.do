/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ALT UNDEREMP DEFS
*** DATE:    09/09/2024
********************************/

**************************
*** RM UNDEREMPLOYMENT ***
**************************
use "../intermediate/clean_acs_data", clear
	keep if ft == 1 & agedum_25_54 == 1
	
gen educ_cat = "hs_or_less"
	replace educ_cat = "aa/some college" if inlist(cln_educ_cat_nbr, 3, 4)
	replace educ_cat = "ba+" if cln_educ_cat_nbr > 4

** IDENTIFY RM CATEGORIES **

preserve
	** COLLAPSE DATA **
	collapse (sum) perwt, by(occ_acs occ_soc bls_occ_title educ_cat postsec_deg)
		bysort occ_acs occ_soc bls: egen tot = sum(perwt)
		gen pct = perwt / tot
		bysort occ_* bls: egen maxpct = max(pct)
		
		gen ba_plus_pct_int = 0
			replace ba_plus_pct_int = pct if educ_cat == "ba+"
			bysort occ_* bls: egen ba_plus_pct = max(ba_plus_pct_int)
			drop ba_plus_pct_int
		
	** PLURALITY DEFINITION **
	gen plurality_int = 0
		replace plurality_int = 1 if pct == maxpct & educ_cat == "ba+"
		bysort occ_* bls: egen college_occ_plurality = max(plurality_int)
		drop plurality_int

	** MAJORITY DEFINITION **
	collapse (sum) pct, by(occ_acs occ_soc bls_occ college_occ_pl ba_plus_pct postsec)
	
	gen majority_int = 0
		replace majority_int = 1 if pct > 0.5 & postsec_deg == 1
		bysort occ_* bls: egen college_occ_majority = max(majority_int)
		drop majority_int
		
	keep occ* bls college_occ* ba_plus_pct
	duplicates drop
	
	tempfile COLLEGEOCCS
	save `COLLEGEOCCS'
restore

** CREATE RM DATASET **
merge m:1 occ_acs occ_soc bls_occ_title using `COLLEGEOCCS'
	assert _merge == 3
	drop _merge

** SAVE DATA **
tempfile RMDATA
save `RMDATA'

******************************
*** DEMING UNDEREMPLOYMENT ***
******************************

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
	replace deming_cat = "management" if inlist(occ, 243, 303, 413, 414, 415) | ///
	 inlist(occ, 433, 448, 450, 470, 503, 558, 628, 803, 823)

rename acs occ2010
keep occ2010 deming_cat
duplicates drop

tempfile DEMING_DEFS
save `DEMING_DEFS'

** MERGE INTO DATASET **
use `RMDATA', clear
merge m:1 occ2010 using `DEMING_DEFS'
	drop if _merge == 2

** CLEAN DATASET **
tab occ2010 if _merge == 1 & cln_educ_cat == "bachelors", sort
tab occ2010 if _merge == 1 & cln_educ_cat == "bachelors", nol sort

replace deming_cat = "other_professional" if occ2010 == 3130 // Registered nurses: occ == 95
replace deming_cat = "other_professional" if occ2010 == 1000 // Computer scientists: occ == 64
replace deming_cat = "management" if occ2010 == 30 // Managers in Marketing, Advert...: occ == 13
replace deming_cat = "management" if occ2010 == 130 // Human Resources Managers: occ == 8
replace deming_cat = "other_professional" if occ2010 == 2140 // Paralegals...: occ == 234
replace deming_cat = "blue_collar" if occ2010 == 9100 // Bus and Ambulance Drivers...: occ == 808
replace deming_cat = "other_professional" if occ2010 == 3530 // Health Technologists..." occ == 208
replace deming_cat = "other_professional" if occ2010 == 1830 // Urban/Regional Planners: occ == 173
replace deming_cat = "blue_collar" if occ2010 == 8230 // Bookbinders/Printing Machine...: occ == 734

gen mi_deming = (mi(deming_cat))
tab mi_deming // 94.85% match
drop mi_deming

gen deming_ba_job = (inlist(deming_cat, "management", "other_professional"))


**********************
*** EXPORT DATASET ***
**********************

gen age_cat = "25-54"
keep age_cat occ_acs occ_soc bls_occ_title ftfy educ_re* college_oc* deming*
	duplicates drop
	isid occ_acs occ_soc
	unique occ_acs occ_soc

tempfile DEMING
save `DEMING'

** OER & EP UNDEREMPLOYMENT **
use "../intermediate/underemployment_data", clear
	keep if bls_occ !="All occupations" & ftfy == 1 & age_cat == "25-54" & ///
	 inlist(cln_educ_cat, "all_workers", "BA+", "bachelors")
	 replace cln_educ_cat = "ba_plus" if cln_educ_cat == "BA+"

** CLEAN BA PREMIUM VARIABLE **
gen oer_ba_job = (educ_req_nbr > 4)
gen ep_ba_job_int = oer_ba_job
	replace ep_ba_job_int = 1 if med_wage > $BA_PREM1 * comp_wage & ///
		 educ_req_nbr == 2 & cln_educ_cat == "bachelors"
	replace ep_ba_job_int = 1 if med_wage > $BA_PREM2 * comp_wage & ///
		 inlist(educ_req_nbr, 3, 4) & cln_educ_cat == "bachelors"
	replace ep_ba_job_int = 1 if educ_req_nbr >= 5 | mi(comp_wage)
	
bysort occ_acs occ_soc: egen ep_ba_job = max(ep_ba_job_int)
	drop ep_ba_job_int

** CALCULATE BA+ SHARES **
preserve
	keep cln_educ_cat occ_acs occ_soc n_wtd
	reshape wide n_wtd, i(occ_*) j(cln_educ_cat) string
	gen ba_plus_share = n_wtdba_plus / n_wtdall
	keep occ_* ba_plus_share
	
	tempfile BAPLUS
	save `BAPLUS'
restore

** PREPARE DATA FOR MERGES **
keep if cln_educ_cat == "all_workers"
keep occ_acs occ_soc bls_occ educ_req_nbr oer_ba_job ep_ba_job med_wage
duplicates drop

** MERGE DATA **
merge 1:1 occ_soc occ_acs using `BAPLUS'
	assert _merge == 3
	drop _merge
	
merge 1:1 occ_acs occ_soc using `DEMING'
	assert _merge == 3
	drop _merge
	
save "../intermediate/alt_underemployment_defs", replace
