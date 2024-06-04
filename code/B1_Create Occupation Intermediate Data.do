/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: GET COUNTS/EARNINGS
*** DATE:    05/22/2024
********************************/

use "../intermediate/underemployment_data", clear

label drop year_lbl
** CREATE COUNTING VARIABLE **
gen n=1

** CREATE LOCAL WITH AGE DUMMIES **
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

*********************************
*** BY OCCUPATION & AGE GROUP ***
*********************************

foreach var of varlist `AGEDUMS' {

	**************
	*** COUNTS ***
	**************

	** BY DETAILED EDUCATION **
	preserve 
		keep if `var' == 1
		* Annual counts
		collapse (sum) n [pw = perwt], ///
		 by(bls_occ_title occ_soc educ_re* cln_educ_cat multyear)
	 
		* 5-year avg. counts
		collapse (mean) n, by(bls_occ_title occ_soc educ_re* cln_educ_cat)
	
		gen age_cat = "`var'"
		tempfile count_D_`var'
		save `count_D_`var''
	restore
	
	** BY AGGREGATE EDUCATION **
	preserve
		keep if `var' == 1
		* Annual counts
		collapse (sum) n [pw = perwt], ///
		 by(bls_occ_title occ_soc educ_re* postsec_deg multyear)
	 
		* 5-year avg. counts
		collapse (mean) n, by(bls_occ_title occ_soc educ_re* postsec_deg)
	
		gen cln_educ_cat = "BA+" if postsec == 1
			replace cln_educ_cat = "less_BA" if postsec==0
			drop postsec
	
		gen age_cat = "`var'"
		tempfile count_A_`var'
		save `count_A_`var''
	restore
	
	****************
	*** EARNINGS ***
	****************

	** ALL WORKERS **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], ///
		 by(bls_occ_title occ_soc educ_re*)
	
		gen cln_educ_cat = "all_workers"
		gen age_cat = "`var'"
		tempfile earn_T_`var'
		save `earn_T_`var''
	restore
	
	** BY DETAILED EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], ///
		 by(bls_occ_title occ_soc educ_re* cln_educ_cat)
		 
		gen age_cat = "`var'"
		tempfile earn_D_`var'
		save `earn_D_`var''
	restore

	** BY AGGREGATE EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], ///
		 by(bls_occ_title occ_soc educ_re* postsec_deg)
	
		gen cln_educ_cat = "BA+" if postsec == 1
		replace cln_educ_cat = "less_BA" if postsec==0
		drop postsec
		gen age_cat = "`var'"
		
		tempfile earn_A_`var'
		save `earn_A_`var''
	restore
}

***********************************
*** EARNINGS ACROSS OCCUPATIONS ***
***********************************

foreach var of varlist `AGEDUMS' {

	** ALL WORKERS **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(year)
		

		gen cln_educ_cat = "all_workers"
		gen age_cat = "`var'"
		drop year

		tempfile earn2_T_`var'
		save `earn2_T_`var''
	restore

	** BY DETAILED EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(cln_educ_cat)

		gen age_cat = "`var'"
		tempfile earn2_D_`var'
		save `earn2_D_`var''
	restore

	** BY AGGREGATE EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(postsec_deg)
	
		gen cln_educ_cat = "BA+" if postsec == 1
			replace cln_educ_cat = "less_BA" if postsec==0
			drop postsec
	
		gen age_cat = "`var'"
		tempfile earn2_A_`var'
		save `earn2_A_`var''
	restore
}
****************************
*** CREATE FINAL DATASET ***
****************************

** CREATE COUNTS DATASET **
clear
tempfile countsdat
save `countsdat', emptyok
count
foreach x in `AGEDUMS' {
    append using `count_D_`x''
	append using `count_A_`x''
	save `"`countsdat'"', replace
} 

** CREATE EARNINGS DATASET **
clear
tempfile earndat
save `earndat', emptyok
count
foreach x in `AGEDUMS' {
	append using `earn_T_`x''
	append using `earn2_T_`x''
    append using `earn_D_`x''
	append using `earn2_D_`x''
	append using `earn_A_`x''
	append using `earn2_A_`x''
	save `"`earndat'"', replace
} 

** CREATE COMBINED DATA **
use `earndat', clear
merge 1:1 bls_occ_title age_cat cln_educ_cat educ_re* using `countsdat', nogen

** CLEAN DATASET **
gen bls_occ_title = "All occupations" if bls == ""
replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
replace age_cat = "all_workers" if age_cat == "all"

** SAVE DATA **
order bls_occ occ_soc educ_req educ_req_n age_cat cln_educ_cat n med_wage
gsort age_cat cln_educ_cat educ_req_nbr occ_soc

save "../intermediate/data_by_occ", replace
