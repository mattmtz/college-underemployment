/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE DETAILED TABLES
*** DATE:    06/10/2024
********************************/

*****************************
*** OCCUPATION-LEVEL DATA ***
*****************************

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
reshape wide n_ mwage_, i(bls occ age_cat educ*) j(cln_educ_cat) string
	order age_cat bls n_* mwage_*
	
** PREMIUM FLAGS **
gen ovl_prem_aa_hs = (mwage_as > $AA_PREM1 * mwage_hs)
	replace ovl_prem_aa_hs = . if mi(mwage_as) | mi(mwage_hs)
	gen suff_aa_hs = (!mi(ovl_prem_aa_hs))

gen ovl_prem_ba_hs = (mwage_ba > $BA_PREM1 * mwage_hs)
	replace ovl_prem_ba_hs = . if mi(mwage_ba) | mi(mwage_hs)
	gen suff_ba_hs = (!mi(ovl_prem_ba_hs))
	
gen ovl_prem_ba_aa = (mwage_ba > $BA_PREM2 * mwage_as)
	replace ovl_prem_ba_aa = . if mi(mwage_ba) | mi(mwage_as)
	gen suff_ba_aa = (!mi(ovl_prem_ba_aa))
	
gen ovl_prem_ma_hs = (mwage_ma > $MA_PREM1 * mwage_hs)
	replace ovl_prem_ma_hs = . if mi(mwage_ma) | mi(mwage_hs)
	gen suff_ma_hs = (!mi(ovl_prem_ma_hs))

gen ovl_prem_ma_aa = (mwage_ma > $MA_PREM2 * mwage_as)
	replace ovl_prem_ma_aa = . if mi(mwage_ma) | mi(mwage_as)
	gen suff_ma_aa = (!mi(ovl_prem_ma_aa))

gen ovl_prem_ma_ba = (mwage_ma > $MA_PREM3 * mwage_ba)
	replace ovl_prem_ma_ba = . if mi(mwage_ma) | mi(mwage_ba)
	gen suff_ma_ba = (!mi(ovl_prem_ma_ba))

** SAVE DATA **
tempfile OVERVIEW
save `OVERVIEW'

save "../intermediate/premium_flags", replace
************************************
*** FIND OCCUPATIONS WITH PREMIA ***
************************************

use "../intermediate/underemployment_data", clear
	keep if inlist(educ_req_nbr, 2, 4, 5) & ///
	 inlist(cln_educ_cat, "associates", "bachelors", "masters")

** PREPARE DATA **
keep bls_occ cln_educ_cat educ_re* agedum* incwage perwt
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

** COUNTS OF OVEREDUCATION **
foreach var of varlist `AGEDUMS' {
preserve
	keep if `var' == 1
	di "`var'"
	
	* Prepare age_cat data
	gen age_cat = "`var'"
	replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
	replace age_cat = subinstr(age_cat, "_", "-", .)
	replace age_cat = "all_workers" if age_cat == "all"
		drop agedum*
		
	* Merge in summary data
	merge m:1 bls educ_req educ_req_nbr age_cat using `OVERVIEW'
		assert _merge != 1
		keep if _merge == 3
		drop _merge

	* Overeducation premium flag
	gen premium = 0
		* HS "required" jobs
		replace premium = 1 if educ_req_nbr == 2 & ///
		 cln_ed == "associates" & incwage > $AA_PREM1 * mwage_bls_educ
		replace premium = 1 if educ_req_nbr == 2 & ///
		 cln_ed == "bachelors" & incwage > $BA_PREM1 * mwage_bls_educ
		replace premium = 1 if educ_req_nbr == 2 & ///
		 cln_ed == "masters" & incwage > $MA_PREM1 * mwage_bls_educ
		* AA "required" jobs
		replace premium = 1 if educ_req_nbr == 4 & ///
		 cln_ed == "bachelors" & incwage > $BA_PREM2 * mwage_bls_educ
		replace premium = 1 if educ_req_nbr == 4 & ///
		 cln_ed == "masters" & incwage > $MA_PREM2 * mwage_bls_educ
		* BA "required" jobs
		replace premium = 1 if educ_req_nbr == 5 & ///
		 cln_ed == "masters" & incwage > $MA_PREM3 * mwage_bls_educ
	
	* Collapse data
	collapse (sum) premium_ = premium [pw = perwt], ///
	 by(age_cat bls_occ cln_educ_cat educ_re*)
	 
	* Reshape wide
	reshape wide premium_, i(bls age_cat educ_re*) j(cln_educ_cat) string
		foreach x of varlist premium_* {
			replace `x' = 0 if mi(`x')
		}
	
	* save data
	tempfile PREM_`var'
	save `PREM_`var''
restore
}

macro list

****************************
*** CREATE FINAL DATASET ***
****************************

** APPEND PREMIUM COUNTS **
clear
tempfile premdat
save `premdat', emptyok
count
foreach x in `AGEDUMS' {
	append using `PREM_`x''
	save `"`premdat'"', replace
} 

** COMBINE ALL DATA **
use `OVERVIEW', clear
	merge 1:1 bls_occ_title age_cat using `premdat', keep(3)
	drop _merge

** EXPORT DATA **
gsort age_cat educ_req_nbr bls
order age_cat educ* bls occ suff_* n_* premium* mwage*

save "../intermediate/premium_data", replace

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("premium_data", replace)
