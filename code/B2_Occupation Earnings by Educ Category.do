/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: GET COUNTS/EARNINGS
*** DATE:    05/22/2024
********************************/

use "../intermediate/underemployment_data", clear

** CREATE LOCAL WITH AGE DUMMIES **
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

*********************
*** BY OCCUPATION ***
*********************

foreach var of varlist `AGEDUMS' {

** ALL WORKERS **
preserve
	keep if `var' == 1
	collapse (p50) med_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
	 by(bls_occ_title occ_soc educ_re*)
	
	gen cln_educ_cat = "all_workers"
	gen age_cat = "`var'"
	tempfile T_`var'
	save `T_`var''
restore
	
** BY DETAILED EDUCATION **
preserve
	keep if `var' == 1
	collapse (p50) med_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
	 by(bls_occ_title occ_soc educ_re* cln_educ_cat)
		 
	gen age_cat = "`var'"
	tempfile D_`var'
	save `D_`var''
restore

** BY AGGREGATE EDUCATION **
preserve
	keep if `var' == 1
	collapse (p50) med_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
	 by(bls_occ_title occ_soc educ_re* postsec_deg)
	
	gen cln_educ_cat = "BA+" if postsec == 1
	replace cln_educ_cat = "less_BA" if postsec==0
	drop postsec
	gen age_cat = "`var'"
		
	tempfile A_`var'
	save `A_`var''
restore

** BY BLS JOB REQUIREMENT EDUCATIONAL ATTAINMENT **
preserve
	keep if `var'==1
	** DROP UNUSABLE EDUC REQ CATEGORIES **
	drop if inlist(educ_req_nbr, 3.5, 7)
		
	collapse (p50) med_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
	 by(bls occ_soc educ_re* agg_educ)
		
	rename agg_educ cln_educ_cat
	gen age_cat = "`var'"
	tempfile Occ_`var'
	save `Occ_`var''
restore
}

**************************
*** ACROSS OCCUPATIONS ***
**************************

foreach var of varlist `AGEDUMS' {

** ALL WORKERS **
preserve
	keep if `var' == 1
	collapse (p50) med_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
	 by(year)
		
	gen cln_educ_cat = "all_workers"
	gen age_cat = "`var'"
	drop year

	tempfile T2_`var'
	save `T2_`var''
restore

** BY DETAILED EDUCATION **
preserve
	keep if `var' == 1
	collapse (p50) med_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
	 by(cln_educ_cat)

	gen age_cat = "`var'"
	tempfile D2_`var'
	save `D2_`var''
restore

** BY AGGREGATE EDUCATION **
preserve
	keep if `var' == 1
	collapse (p50) med_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
	 by(postsec_deg)
	
	gen cln_educ_cat = "BA+" if postsec == 1
		replace cln_educ_cat = "less_BA" if postsec==0
		drop postsec
	
	gen age_cat = "`var'"
	tempfile A2_`var'
	save `A2_`var''
restore
}

****************************
*** CREATE FINAL DATASET ***
****************************

clear
tempfile earndat
save `earndat', emptyok
count
foreach x in `AGEDUMS' {
	append using `T_`x''
	append using `T2_`x''
    append using `D_`x''
	append using `D2_`x''
	append using `A_`x''
	append using `A2_`x''
	append using `Occ_`x''
	save `"`earndat'"', replace
} 

** CLEAN DATASET **
replace bls_occ_title = "All occupations" if bls == ""
replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
replace age_cat = "all_workers" if age_cat == "all"

** CREATE COMBINED DATA **
merge 1:1 bls_occ_title age_cat cln_educ_cat educ_re* ///
 using "../intermediate/counts_by_occ"
	assert _merge==3
	drop _merge

** SAVE DATA **
order bls_occ occ_soc educ_req educ_req_n age_cat cln_educ_cat n med_wage
gsort age_cat cln_educ_cat educ_req_nbr occ_soc

save "../intermediate/data_by_occ", replace

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("data_by_occ", replace)
