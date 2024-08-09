/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: GET COUNTS DATA
*** DATE:    06/04/2024
********************************/

use "../intermediate/clean_acs_data", clear

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

	collapse (sum) n_raw = n n_wtd = perwt, ///
	 by(bls_occ_title occ_soc educ_re* ftfy)

	gen cln_educ_cat = "all_workers"
	gen age_cat = "`var'"
	tempfile T_`var'
	save `T_`var''
restore

** BY DETAILED EDUCATION **
preserve 
	keep if `var' == 1
	
	collapse (sum) n_raw = n n_wtd = perwt, ///
	 by(bls_occ_title occ_soc educ_re* cln_educ_cat ftfy)

	gen age_cat = "`var'"
	tempfile D_`var'
	save `D_`var''
restore
	
** BY AGGREGATE EDUCATION **
preserve 
	keep if `var' == 1
	
	collapse (sum) n_raw = n n_wtd = perwt, ///
	 by(bls_occ_title occ_soc educ_re* postsec_deg ftfy)
	 
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
	drop if educ_req_nbr == 7
	
	/* FIX 22-23 LOW AA PROBLEM */
	if ("`var'" == "agedum_22_23") {
	
	di "`var'"
		replace agg_educ = "bls_educ" if educ_req_nbr == 4 & ///
		inlist(cln_educ_cat, "some_college", "associates")
		
	} 
	else {
		di "`var'"
	}
	
	
	collapse (sum) n_raw = n n_wtd = perwt, ///
	 by(bls_occ_title occ_soc educ_re* agg_educ ftfy)

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
	
	collapse (sum) n_raw = n n_wtd = perwt, by(year ftfy)
	
	gen cln_educ_cat = "all_workers"
	gen age_cat = "`var'"
	drop year
	tempfile T2_`var'
	save `T2_`var''
restore


** BY DETAILED EDUCATION **
preserve
	keep if `var' == 1
	
	collapse (sum) n_raw = n n_wtd = perwt, by(cln_educ_cat ftfy)

	gen age_cat = "`var'"
	tempfile D2_`var'
	save `D2_`var''
restore

** BY AGGREGATE EDUCATION **
preserve
	keep if `var' == 1
	
	collapse (sum) n_raw = n n_wtd = perwt, by(postsec_deg ftfy)

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
gen int_count = 0
	replace int_count = n_raw if cln_educ_cat == "bls_educ"
	bysort age_cat bls ftfy: egen comp_count = max(int_count)
	replace comp_count = 0 if ftfy == 0 | mi(educ_req)
	
gen suff_flag = (comp_count >= $NFLAG )
	replace suff_flag = 1 if educ_req_nbr == 1 | educ_req_nbr >= 5

drop int_count

** SAVE DATA **
order bls_occ occ_soc educ_req educ_req_n age_cat cln_educ_cat n_w n_r suff_flag
gsort age_cat cln_educ_cat educ_req_nbr occ_soc

save "../intermediate/counts_by_occ", replace
