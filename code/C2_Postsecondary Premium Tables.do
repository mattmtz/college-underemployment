/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE DETAILED TABLES
*** DATE:    06/10/2024
********************************/

***************************
*** SET UP DATA FILTERS ***
***************************

use "../intermediate/data_by_occ", clear

** KEEP OBSERVATIONS OF INTEREST **	
keep if inlist(cln_educ_cat, "all_workers", "bls_educ", "hs", ///
 "bachelors", "associates", "masters")
keep if inlist(educ_req_nbr, 2, 4, 5)

** SET LOW-N OBS TO MISSING **
replace med_wage = . if low_n_flag == 1
drop avg_wage low_n

** RESHAPE DATA **
rename (n med_wage) (n_ mwage_)
reshape wide n_ mwage_, i(bls occ educ* age_cat) j(cln_educ_cat) string
	order age_cat bls occ educ_* n_* mwage_*
	
** PREMIUM FLAGS **
gen prem_flag_aa_hs = (mwage_as > $AA_PREM1 * mwage_hs)
	replace prem_flag_aa_hs = . if mi(mwage_as) | mi(mwage_hs)

gen prem_flag_ba_hs = (mwage_ba > $BA_PREM1 * mwage_hs)
	replace prem_flag_ba_hs = . if mi(mwage_ba) | mi(mwage_hs)
	
gen prem_flag_ba_aa = (mwage_ba > $BA_PREM2 * mwage_as)
	replace prem_flag_ba_aa = . if mi(mwage_ba) | mi(mwage_as)
	
gen prem_flag_ma_hs = (mwage_ma > $MA_PREM1 * mwage_hs)
	replace prem_flag_ma_hs = . if mi(mwage_ma) | mi(mwage_hs)

gen prem_flag_ma_aa = (mwage_ma > $MA_PREM2 * mwage_as)
	replace prem_flag_ma_aa = . if mi(mwage_ma) | mi(mwage_as)

gen prem_flag_ma_ba = (mwage_ma > $MA_PREM3 * mwage_ba)
	replace prem_flag_ma_ba = . if mi(mwage_ma) | mi(mwage_ba)

** SAVE DATA **
tempfile OVERVIEW
save `OVERVIEW'

************************************
*** FIND OCCUPATIONS WITH PREMIA ***
************************************

use "../intermediate/underemployment_data", clear
	keep if inlist(educ_req_nbr, 2, 3)

** PREPARE DATA **
keep bls_occ occ_soc educ_re* agedum* incwage perwt
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

merge 1:m bls occ_soc educ_req educ_req_nbr age_cat using `OVERVIEW'
