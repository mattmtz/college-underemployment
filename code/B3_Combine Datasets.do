/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE EXCEL TABLES
*** DATE:    06/03/2024
********************************/

*********************************************
*** SETUP TO MERGE EDUCATION REQUIREMENTS ***
*********************************************

** DATA BY OCCUPATION **
use "../intermediate/data_by_educ_req", clear
	drop if mi(occ_soc)
	drop cln_educ_cat mwage
	tempfile EDUC1
	save `EDUC1'
	
** DATA BY EDUCATION REQUIREMENT
use "../intermediate/data_by_educ_req", clear
	keep if mi(occ_soc)
	keep age_cat bls cln_educ_cat mwage
	rename mwage mwage_
	replace cln_educ_cat = "BA_plus" if cln_educ_cat == "BA+"
	reshape wide mwage, i(age bls) j(cln_educ_cat) string
	tempfile EDUC2
	save `EDUC2'
	
**************************************
*** CREATE OCCUPATION-LEVEL TABLES ***
**************************************

use "../intermediate/data_by_occ", clear

** ASSIGN MISSING VALUES TO LOW-N CATEGORIES **
replace med_wage = . if n < $NFLAG

** RESHAPE LONG TO WIDE **
rename (n med_wage) (n_ mwage_)
replace cln_educ_cat = "BA_plus" if cln_educ_cat == "BA+"
reshape wide n_ mwage_, i(bls occ_soc educ_re* age_cat) j(cln_educ) string
	drop n_all_workers
	gen n_total = n_less_BA + n_BA_plus

** MERGE EDUCATION REQUIREMENTS DATA **
merge 1:1 age_cat bls occ educ_r* using `EDUC1', nogen

** APPEND AGGREGATE EDUCATION REQUIREMENTS DATA **
append using `EDUC2'

** CREATE FLAG FOR BA PREMIUM **
gen mwage_ba_premium_over_hs = (mwage_bach / mwage_hs - 1 > $BA_PREMIUM )
	replace mwage_ba_prem = 0 if mi(mwage_bach) | mi(mwage_hs)

** EXPORT VARIABLES **
order bls occ educ_r* age_cat n_less_hs n_hs n_some n_assoc n_bach n_mast /// 
 n_doc n_less_BA n_BA_plus n_tot mwage_all mwage_less_hs mwage_hs mwage_some ///
 mwage_assoc mwage_bach mwage_mast mwage_doc mwage_less_BA mwage_BA_plus ///
 mwage_bls mwage_over mwage_ba_premium avgwage_bls
 
gsort age_cat bls
 
export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("data_by_occ", replace)
 
****************************
*** CREATE SUMMARY TABLE ***
****************************

********************************************************
*** CREATE OCCUPATIONAL EDUCATION REQUIREMENTS TABLE ***
********************************************************

use "../intermediate/data_by_occ", clear

keep bls_occ_title occ_soc educ_req*
duplicates drop
gsort educ_req_nbr occ_soc

** CLEAN REQUIREMENT VALUES **
replace educ_req = "Associate's" if strpos(educ_req, "Assoc")
replace educ_req = "Bachelor's" if strpos(educ_req, "Bachelor")
replace educ_req = "HS or equivalent" if strpos(educ_req, "High school")
replace educ_req = "Master's" if strpos(educ_req, "Master's")
replace educ_req = "No formal credential" if strpos(educ_req, "No formal")
replace educ_req = "Some college" if strpos(educ_req, "Some college")
replace educ_req = "Doctoral/professional" if strpos(educ_req, "Doctoral")
replace educ_req = "Nondegree award" if strpos(educ_req, "nondegree award")

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("reqs", replace)
