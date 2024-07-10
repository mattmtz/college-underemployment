/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE SUMMARY TABLES
*** DATE:    06/10/2024
********************************/

***********************************
*** BLS EDUC VS. OVEREDUC TABLE ***
***********************************

use "../intermediate/data_by_occ_wide", clear
	drop if inlist(educ_req_nbr, 3.5, 7) | mi(educ_req_nbr)
	keep age bls occ educ* *_undereduc *_bls_educ *_overeduc
	
*** CREATE KEY INDICATORS ***
gen tot = 1
gen maj_overeduc = (nwtd_overeduc > nwtd_bls_educ + nwtd_undereduc)
	replace maj_overeduc = 0 if mi(maj_overeduc)
gen suff_both = (suff_overeduc + suff_bls_educ == 2)

*** MEDIAN/AVG WAGES LOOP ***
local CAT "overeduc bls_educ"
foreach x in `CAT' {
	replace med_wage_`x' = . if suff_both == 0
	replace avg_wage_`x' = . if suff_both == 0
	bysort age educ_req: egen cat_med_wage_`x' = median(med_wage_`x')
}
	
** CREATE MEDIAN/AVG OVEREDUCATION SHARES **
gen overeduc_share = nwtd_overeduc/(nwtd_overeduc + nwtd_bls + nwtd_undereduc) ///
 if maj == 1
	bysort age educ_req: egen overeduc_share_med = median(overeduc_share)
	bysort age educ_req: egen overeduc_share_avg = mean(overeduc_share)
	 
** COLLAPSE DATA **
collapse (sum) tot suff_* maj_ov overeduc_p* ///
 (mean) overeduc_share_* cat_med_wage_*, by(age_cat educ_re*)

drop suff_undereduc

** NOTE: MISSING DATA INDICATES NO MAJORITY OVEREDUC OCCS **
tab maj_overeduc if mi(overeduc_share_med) | mi(overeduc_share_avg)
	
** EXPORT DATA **
order age_cat educ_re* tot suff* maj_overeduc cat_* overeduc_sh*
gsort age_cat educ_req_nbr
	drop educ_req_nbr

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("overeduc_overview", replace)

*****************
*** BA+ TABLE ***
*****************

use "../intermediate/data_by_occ_wide", clear
	drop if inlist(educ_req_nbr, 3.5, 7) | mi(educ_req_nbr)
	keep age bls occ educ* *_BA_plus *_less_BA

gen tot = 1
gen suff_both = (suff_less_BA + suff_BA_plus == 2)

** CALCULATE BA+ SHARES **
gen BA_plus_share = nwtd_BA_plus / (nwtd_BA_plus + nwtd_less_BA)
	replace BA_plus_share = . if suff_both == 0
	
** MEDIAN WAGES LOOP **
local CAT "BA_plus less_BA"
foreach x in `CAT' {
	replace med_wage_`x' = . if suff_both == 0
	bysort age educ_req: egen cat_med_wage_`x' = median(med_wage_`x')
}

** COLLAPSE DATA **
collapse (sum) tot suff_* (mean) avg_BA_plus_share = BA_plus_sh cat_med_wage_*, ///
 by(age_cat educ_re*)
 
** EXPORT DATA **
order age_cat educ_re* tot suff_* avg_BA_plus_sh cat_med_wage*
gsort age_cat educ_req_nbr
	drop educ_req_nbr
	
export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("BA_plus_overview", replace)
