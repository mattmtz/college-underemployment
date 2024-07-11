/************************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CALCULATE UNDEREMPLOYED
*** DATE:    07/12/2024
************************************/

***********************************************
*** DEFINE INDIVIDUAL-LEVEL UNDEREMPLOYMENT ***
***********************************************

*** PREPARE OCCUPATION-LEVEL DATA ***
use "../intermediate/data_by_occ", clear
	keep if cln_educ_cat == "bachelors" & suff_flag == 1
	keep bls age_cat comp_wage ovl_prem_ba suff_flag
	
	tempfile OCCDAT
	save `OCCDAT'

*** DEFINE OVEREDUCATION FOR BA HOLDERS ***
use "../intermediate/clean_acs_data", clear

unab AGEDUMS: agedum_*
di "`AGEDUMS'"
foreach var of varlist `AGEDUMS' {

preserve
	keep if `var' == 1 & cln_educ_cat == "bachelors"
	
	* Prepare age_cat data
	gen age_cat = "`var'"
	replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
	replace age_cat = subinstr(age_cat, "_", "-", .)
	replace age_cat = "all_workers" if age_cat == "all"
		drop agedum*
	
	* Merge in summary data
	merge m:1 bls age_cat using `OCCDAT'
		drop if _merge == 2
		drop _merge
		
	* Create underemployment count
	gen underemp = perwt
		replace underemp = 0 if incwage > $BA_PREM1 * comp_wage & ///
		 educ_req_nbr == 2
		replace underemp = 0 if incwage > $BA_PREM2 * comp_wage & ///
		 inlist(educ_req_nbr, 3, 4)
		replace underemp = 0 if educ_req_nbr >= 5 | mi(comp_wage)
	
	* Collapse data
	collapse (sum) underemp, by(bls age_cat cln_educ_cat) 
	
	tempfile U_`var'
	save `U_`var''
restore
}

*********************************************
*** CREATE FINAL OCCUPATION-LEVEL DATASET ***
*********************************************

*** APPEND DATA ***
clear
tempfile underemp
save `underemp', emptyok
count
foreach x in `AGEDUMS' {
	append using `U_`x''
	save `"`underemp'"', replace
}

*** MERGE TO FULL DATASET ***
use "../intermediate/data_by_occ", clear
	merge 1:1 bls age_cat cln_educ using `underemp', nogen

*** CALCULATE BLS UNDEREMPLOYMENT ***
gen underemp_bls = n_wtd
	replace underemp_bls = 0 if suff_flag == 0
	replace underemp_bls = . if cln_educ_cat != "bachelors" | ///
	 bls == "All occupations"
	
*** EXPORT DATA ***	
order age_c cln_educ_cat bls occ educ_r* n* comp_count suff comp_wage ///
 med_wage avg_wage ovl_prem underemp*
gsort age_cat cln_educ_cat educ_req_nbr bls
	
save "../intermediate/underemployment_data", replace

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("data_by_occ", replace)
