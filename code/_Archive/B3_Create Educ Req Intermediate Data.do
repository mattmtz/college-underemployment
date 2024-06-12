/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE EDUC REQ DATA
*** DATE:    05/20/2024
********************************/

use "../intermediate/data_by_occ", clear
	drop if inlist(educ_req_nbr, 3.5, 7) | mi(educ_req_nbr)

** KEEP ONLY RELEVANT OCCUPATIONS **
keep if inlist(cln_educ_cat, "undereduc", "bls_educ", ///
 "overeduc", "less_BA", "BA+", "bachelors", "hs")
 
** PREP DATA FOR RESHAPE **
replace cln_educ_cat = "BA_plus" if cln_educ_cat == "BA+"
replace cln_educ_cat = "BA" if cln_educ_cat == "bachelors"
replace cln_educ_cat = "HS" if cln_educ_cat == "hs"

rename (n med_wage avg_wage) (n_ mwage_ awage_)

gen suff_ = (low_n_flag == 0)
	drop low_n

** CREATE AGE CAT/OCC.-LEVEL DATA **
reshape wide n_ mwage_ awage_ suff_, i(age_cat bls occ educ*) j(cln_educ) string

gen tot = 1
order age_cat bls occ educ* tot suff_* n_* mwage_* awage_*
	
** CLEAN VARIABLES **
foreach var of varlist suff_* n_* {
	replace `var' = 0 if mi(`var')
}

save "../intermediate/data_by_occ_wide", replace
