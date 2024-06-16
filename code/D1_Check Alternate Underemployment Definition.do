/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE SUMMARY TABLES
*** DATE:    06/10/2024
********************************/

use "../intermediate/data_by_occ", clear

*** PREP DATA FOR RESHAPE ***
keep if inlist(cln_educ_cat, "less_BA", "BA+") & educ_req_nbr == 5 & suff == 1
keep bls age_cat educ_req* cln_educ_cat n_wtd

replace cln_educ_cat = "BA_plus" if cln_educ_cat == "BA+"

rename n_wtd n_ 

*** RESHAPE DATA ***
reshape wide n_, i(age_cat bls educ*) j(cln_educ) string
	replace n_BA = 0 if mi(n_BA)
	replace n_less = 0 if mi(n_less)
	
*** COLLAPSE DATA ***
gen extra_undereduc_flag = (n_less > n_BA)
collapse (sum) n_BA, by(age_cat extra)

*** CALCULATE SHARE OF WORKERS IN OCCUPATIONS WITH MAJORITY UNDEREDUCATED ***
reshape wide n_BA, i(age_cat) j(extra)
	rename (n_BA_plus0 n_BA_plus1) (more_BA less_BA)
	gen pct = less_BA / (more_BA + less_BA)

tab age_cat, sum(pct)
