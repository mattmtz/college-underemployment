/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE MAIN DATASET
*** DATE:    05/20/2024
********************************/

***************************
*** OCCUPATIONAL COUNTS ***
***************************

use "../intermediate/counts_by_occ", clear

** COUNTS OF OCCUPATIONS BY EDUC REQ **
preserve
	drop if inlist(educ_req_nbr, 3.5, 7)
	*unique bls
	*unique bls if cln_educ_cat == "bls_educ"
	keep if cln_educ_cat == "bls_educ"
	gen tot_occs = 1
	gen usable_occs = (low_n_flag == 0)
	
	** SAVE LIST OF USABLE OCCUPATIONS **
	levelsof occ_soc
	collapse (sum) tot_occs usable_occs, by(age_cat educ_req)
	
	tempfile TOT_OCCS
	save `TOT_OCCS'
restore

** IDENTIFY ONLY RELEVANT OCCUPATIONS **
preserve
	keep if cln_educ_cat == "bls_educ" & low_n_flag == 0
	collapse (sum) n, by(age_cat bls)
		drop n
		
	tempfile RELEVANT_OCCS
	save `RELEVANT_OCCS'
restore

** KEEP ONLY RELEVANT OCCUPATIONS **
keep if inlist(cln_educ_cat, "undereduc", "bls_educ", "overeduc")
merge m:1 age_cat bls using `RELEVANT_OCCS', keep(2 3) nogen

** DEFINE OVEREDUC DUMMY **
rename n n_
drop low_n_flag occ_soc
reshape wide n_, i(age_cat bls educ_req) j(cln_educ_cat) string
	replace n_over = 0 if mi(n_over)
	replace n_under = 0 if mi(n_under)

gen majority_overeduc = (n_overeduc > n_bls + n_undereduc)

** NUMBER OF OCCS WITH MAJORITY OVEREDUC BY AGE & EDUC REQ **
collapse (sum) majority_overeduc, by(age_cat educ_re*)
	
** ADD COUNTS OF OCC TYPE BY AGE & EDUC REQ **
merge 1:1 age_cat educ_req using `TOT_OCCS', nogen

** SAVE DATA **
order age_cat educ_re* tot usable majority
gsort age_cat educ_req_nbr

tempfile OCC_COUNTS
save `OCC_COUNTS'

**************************
*** 

** SET UP DATA **
use "../intermediate/underemployment_data", clear

keep serial perwt age agedum* cln_educ_cat postsec agg_educ_lvl ///
 bls_occ occ_soc educ_req incwage
 
order serial perwt age agedum* cln_educ_cat postsec agg_educ_lvl ///
 bls_occ occ_soc educ_req incwage
