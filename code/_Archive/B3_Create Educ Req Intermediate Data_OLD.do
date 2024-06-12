/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE MAIN DATASET
*** DATE:    05/20/2024
********************************/

use "../intermediate/underemployment_data", clear

** CREATE LOCAL WITH AGE DUMMIES **
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

************************************************************
*** EARNINGS BY AGE AND AGGREGATE EDUCATION REQUIREMENTS ***
************************************************************

foreach var of varlist `AGEDUMS' {

	** ALL WORKERS **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(educ_req)
	
		gen cln_educ_cat = "all_workers"
		gen age_cat = "`var'"
		tempfile T_`var'
		save `T_`var''
	restore

	** BY DETAILED EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(cln_educ_cat educ_req)
		
		gen age_cat = "`var'"
		tempfile D_`var'
		save `D_`var''
	restore

	** BY AGGREGATE EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(postsec_deg educ_req)

		gen cln_educ_cat = "BA+" if postsec == 1
			replace cln_educ_cat = "less_BA" if postsec==0
			drop postsec
		gen age_cat = "`var'"

		tempfile A_`var'
		save `A_`var''
	restore
}

****************************
*** CREATE FINAL DATASET ***
****************************

clear

tempfile fulldat
save `fulldat', emptyok
count
foreach x in `AGEDUMS' {
	append using `T_`x''
    append using `D_`x''
	append using `A_`x''
	save `"`fulldat'"', replace
} 

use `fulldat', clear

** CLEAN DATASET **
replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
replace age_cat = "all_workers" if age_cat == "all"

gen bls_occ_title = "All occupations requiring " + strlower(educ_req)
	drop educ_req
	
** EXPORT DATA **
order age_cat bls_occ_title cln_educ_cat med_wage 
gsort age_cat bls

save "../intermediate/data_by_educ_req", replace
