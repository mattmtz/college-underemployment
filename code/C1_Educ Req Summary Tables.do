/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE OCC COUNTS TABLE
*** DATE:    05/20/2024
********************************/

**********************
*** CREATE DATASET ***
**********************

use "../intermediate/data_by_occ", clear
	drop if inlist(educ_req_nbr, 3.5, 7) | mi(educ_req_nbr)

** KEEP ONLY RELEVANT OCCUPATIONS **
keep if inlist(cln_educ_cat, "undereduc", "bls_educ", ///
 "overeduc", "BA+", "bachelors", "hs")
 
** PREP DATA FOR RESHAPE **
replace cln_educ_cat = "BA_plus" if cln_educ_cat == "BA+"
replace cln_educ_cat = "BA" if cln_educ_cat == "bachelors"
replace cln_educ_cat = "HS" if cln_educ_cat == "hs"

levelsof cln_educ_cat, clean local(CAT)

rename (n med_wage avg_wage) (n_ mwage_ awage_)

gen suff_ = (low_n_flag == 0)
	drop low_n

** CREATE AGE CAT/OCC.-LEVEL DATA **
reshape wide n_ mwage_ awage_ suff_, i(age_cat bls occ educ*) j(cln_educ) string

gen tot = 1
order age_cat bls occ educ* tot suff_* n_* mwage_* awage_*
	
** CLEAN VARIABLES **
foreach var of varlist suff_* {
	replace `var' = 0 if mi(`var')
}

foreach x in `CAT' {
	replace mwage_`x' = . if suff_`x' == 0
	replace awage_`x' = . if suff_`x' == 0
}

***********************************
*** BLS EDUC VS. OVEREDUC TABLE ***
***********************************

preserve
	keep age bls occ educ* tot *_bls_educ *_overeduc
	
restore

*****************
*** BA+ TABLE ***
*****************


*********************
** BA VS. HS TABLE **
*********************
