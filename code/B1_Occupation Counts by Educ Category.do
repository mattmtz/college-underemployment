/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: GET COUNTS DATA
*** DATE:    06/04/2024
********************************/

use "../intermediate/underemployment_data", clear

** CREATE COUNTING VARIABLE **
gen n=1

** CREATE LOCAL WITH AGE DUMMIES **
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

*********************************************
*** CREATE COUNTS BY EDUCATION CATEGORIES ***
*********************************************

foreach var of varlist `AGEDUMS' {

** ALL WORKERS **
preserve 
	keep if `var' == 1
	* Annual counts
	collapse (sum) n [pw = perwt], ///
	 by(bls_occ_title occ_soc educ_re* multyear)
	 
	* 5-year avg. counts
	collapse (mean) n, by(bls_occ_title occ_soc educ_re*)
	
	gen cln_educ_cat = "all_workers"
	gen age_cat = "`var'"
	tempfile T_`var'
	save `T_`var''
restore

** BY DETAILED EDUCATION **
preserve 
	keep if `var' == 1
	* Annual counts
	collapse (sum) n [pw = perwt], ///
	 by(bls_occ_title occ_soc educ_re* cln_educ_cat multyear)
	 
	* 5-year avg. counts
	collapse (mean) n, by(bls_occ_title occ_soc educ_re* cln_educ_cat)
	
	gen age_cat = "`var'"
	tempfile D_`var'
	save `D_`var''
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
	tempfile A_`var'
	save `A_`var''
restore

** BY BLS JOB REQUIREMENT EDUCATIONAL ATTAINMENT **
preserve 
	keep if `var' == 1
	** DROP UNUSABLE EDUC REQ CATEGORIES **
	drop if inlist(educ_req_nbr, 3.5, 7)
	
	* Annual counts
	collapse (sum) n [pw = perwt], ///
	 by(bls_occ_title occ_soc educ_re* agg_educ multyear)
	 
	* 5-year avg. counts
	collapse (mean) n, by(bls_occ_title occ_soc educ_re* agg_educ)
		
	rename agg_educ cln_educ_cat
	
	gen age_cat = "`var'"
	tempfile JR_`var'
	save `JR_`var''
restore
}

**************************
*** ACROSS OCCUPATIONS ***
**************************

foreach var of varlist `AGEDUMS' {

** ALL WORKERS **
preserve 
	keep if `var' == 1
	* Annual counts
	collapse (sum) n [pw = perwt], by(multyear year)
	 
	* 5-year avg. counts
	collapse (mean) n, by(year)
	
	gen cln_educ_cat = "all_workers"
	gen age_cat = "`var'"
	drop year
	tempfile T2_`var'
	save `T2_`var''
restore


** BY DETAILED EDUCATION **
preserve
	keep if `var' == 1
	* Annual counts
	collapse (sum) n [pw = perwt], by(multyear cln_educ_cat)
	
	* 5-yr avg. counts
	collapse (mean) n, by(cln_educ_cat)
	
	gen age_cat = "`var'"
	tempfile D2_`var'
	save `D2_`var''
restore

** BY AGGREGATE EDUCATION **
preserve
	keep if `var' == 1
	* Annual counts
	collapse (sum) n [pw = perwt], by(multyear postsec_deg)
	
	* 5-yr avg. counts
	collapse (mean) n, by(postsec_deg)
	
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
tempfile countsdat
save `countsdat', emptyok
count
foreach x in `AGEDUMS' {
	append using `T_`x''
	append using `T2_`x''
	append using `D_`x''
	append using `D2_`x''
    append using `A_`x''
	append using `A2_`x''
	append using `JR_`x''
	save `"`countsdat'"', replace
} 

** CLEAN DATASET **
replace bls_occ_title = "All occupations" if bls == ""
replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
replace age_cat = "all_workers" if age_cat == "all"

** CREATE FLAG FOR TOO FEW OBSERVATIONS **
gen low_n_flag = (n < $NFLAG ) 

** SAVE DATA **
order bls_occ occ_soc educ_req educ_req_n age_cat cln_educ_cat n low_n_flag
gsort age_cat cln_educ_cat educ_req_nbr occ_soc

save "../intermediate/counts_by_occ", replace
