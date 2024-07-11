/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: GET COUNTS/EARNINGS
*** DATE:    05/22/2024
********************************/

use "../intermediate/clean_acs_data", clear

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

*******************************
*** CREATE COMBINED DATASET ***
*******************************

*** COMBINE ALL DATA ***
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

** ADD EMPLOYEE COUNTS **
merge 1:1 bls_occ_title age_cat cln_educ_cat educ_re* ///
 using "../intermediate/counts_by_occ"
	assert _merge==3
	drop _merge

*** CREATE FINAL SUFFICIENCY FLAG ***
gen int_count = 0
	replace int_count = n_raw if cln_educ_cat == "bls_educ"
	bysort age_cat bls_occ_title: egen comp_count = max(int_count)

gen int_flag = 0
	replace int_flag = 1 if mi(educ_req) | inlist(educ_req_nbr, 3.5, 7)
	replace int_flag = 1 if comp_count >= $NFLAG & !mi(comp_count)
	
rename suff_flag int_suff_flag
gen suff_flag = (int_suff_flag == 1 & int_flag == 1)

*** CREATE COMPARISON VALUE FOR PREMIUM CALCULATION ***
gen int_wage = 0
	replace int_wage = med_wage if cln_educ_cat == "bls_educ"
	bysort age_cat bls_occ_title: egen comp_wage = max(int_wage)
	replace comp_wage = . if inlist(educ_req_nbr, 3.5, 7) | mi(educ_req) | ///
	 suff_flag == 0
	
*** BA PREMIUM FLAG ***
gen ovl_prem_ba = (med_wage > $BA_PREM1 * comp_wage & cln_educ == "bachelors" ///
               & educ_req_nbr == 2)
	replace ovl_prem_ba = 1 if med_wage > $BA_PREM2 * comp_wage & ///
	 cln_educ == "bachelors" & inlist(educ_req_nbr, 3, 4)
	replace ovl_prem_ba = 0 if med_wage <= $BA_PREM2 * comp_wage & ///
	 cln_educ == "bachelors" & inlist(educ_req_nbr, 3, 4)
	replace ovl_prem_ba = . if cln_educ != "bachelors" | educ_req_nbr > 4

*** SAVE DATA ***
drop int_*
order age_c bls_occ occ_soc educ_req educ_req_n cln_educ n_wtd n_raw suff ///
 comp_count comp_wage med_wage avg_wage ovl_prem_ba
gsort age_cat cln_educ_cat educ_req_nbr bls

save "../intermediate/data_by_occ", replace
