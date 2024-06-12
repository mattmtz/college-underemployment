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
	keep age bls occ educ* tot *_undereduc *_bls_educ *_overeduc
	
** CREATE KEY INDICATORS
gen maj_overeduc = (n_overeduc > n_bls_educ + n_undereduc)
	replace maj_overeduc = 0 if mi(maj_overeduc)
gen suff_both = (suff_overeduc + suff_bls_educ == 2)

** MEDIAN/AVG WAGES LOOP **
local CAT "overeduc bls_educ"
foreach x in `CAT' {
	replace mwage_`x' = . if suff_`x' == 0
	replace awage_`x' = . if suff_`x' == 0
	bysort age educ_req: egen med_mwage_`x' = median(mwage_`x')
}
	
** CREATE MEDIAN/AVG OVEREDUCATION SHARES **
gen overeduc_share = n_overeduc/(n_overeduc + n_bls + n_undereduc) if maj == 1
	bysort age educ_req: egen overeduc_share_med = median(overeduc_share)
	bysort age educ_req: egen overeduc_share_avg = mean(overeduc_share)
	 
** CALCULATE OVEREDUCATION PREMIA **
gen overeduc_prem_med = (mwage_overeduc > $OVEREDUC_PREMIUM * mwage_bls_educ)
	replace overeduc_prem_med = 0 if suff_both == 0
gen overeduc_prem_avg = (awage_overeduc > $OVEREDUC_PREMIUM * awage_bls_educ)
	replace overeduc_prem_avg = 0 if suff_both == 0
		
** COLLAPSE DATA **
collapse (sum) tot suff_* maj_ov overeduc_p* ///
 (mean) overeduc_share_* med_mwage_*, by(age_cat educ_re*)

drop suff_undereduc

** NOTE: MISSING DATA INDICATES NO MAJORITY OVEREDUC OCCS **
tab maj_overeduc if mi(overeduc_share_med) | mi(overeduc_share_avg)
	
** EXPORT DATA **
order age_cat educ_re* tot suff* maj_overeduc overeduc_sh* overeduc_p*
gsort age_cat educ_req_nbr
	drop educ_req_nbr

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("overeduc_overview", replace)

*****************
*** BA+ TABLE ***
*****************

use "../intermediate/data_by_occ_wide", clear
	keep age bls occ educ* tot *_BA_plus *_less_BA

gen suff_both = (suff_less_BA + suff_BA_plus == 2)

** CALCULATE BA+ SHARES **
gen BA_plus_share = n_BA_plus / (n_BA_plus + n_less_BA)

** MEDIAN WAGES LOOP **
local CAT "BA_plus less_BA"
foreach x in `CAT' {
	replace mwage_`x' = . if suff_`x' == 0
	bysort age educ_req: egen med_mwage_`x' = median(mwage_`x')
}

** COLLAPSE DATA **
collapse (sum) tot suff_* (mean) avg_BA_plus_share = BA_plus_sh med_mwage_*, ///
 by(age_cat educ_re*)
 
** EXPORT DATA **
order age_cat educ_re* tot suff_* avg_BA_plus_sh med_mwage_*
gsort age_cat educ_req_nbr
	drop educ_req_nbr
	
export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("BA_plus_overview", replace)
