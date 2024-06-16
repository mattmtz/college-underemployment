/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE SUMMARY TABLES
*** DATE:    06/17/2024
********************************/

**********************************
*** PREP OCCUPATION-LEVEL DATA ***
**********************************

*** FILTER DATA ***
use "../intermediate/data_by_occ", clear
	keep if inlist(cln_educ_cat, "bls_educ", "associates", "bachelors", "masters")
	drop avg_wage suff_flag
	*drop if inlist(cln_educ_cat, "BA+", "less_BA", "all_workers", "undereduc", "overeduc")

*** RESHAPE DATA ***
replace cln_educ_cat = "_" + cln_educ_cat if ///
 inlist(cln_educ_cat, "bls_educ", "less_hs", "hs") 
replace cln_educ_cat = "_somecol" if cln_educ_cat == "some_college"
replace cln_educ_cat = "_aa" if cln_educ_cat == "associates"
replace cln_educ_cat = "_ba" if cln_educ_cat == "bachelors"
replace cln_educ_cat = "_ma" if cln_educ_cat == "masters"
replace cln_educ_cat = "_phd" if strpos(cln_educ_cat, "doctor")

reshape wide n_* med_wage prem*, i(bls occ educ* age comp_wage) ///
 j(cln_educ_cat) string

*** CREATE SUFFICIENCY TAGS ***
gen suff_aa = (n_raw_bls >= $NFLAG & n_raw_aa >= $NFLAG )
gen suff_ba = (n_raw_bls >= $NFLAG & n_raw_ba >= $NFLAG )
gen suff_ma = (n_raw_bls >= $NFLAG & n_raw_ma >= $NFLAG )

order bls occ educ* age_cat suff_* comp_wage n_raw* n_wtd* med_wage_* prem_*

*** DROP BLANK VARIABLES ***
unab PREMS: prem_*
foreach var of varlist `PREMS' {
	capture assert mi(`var')
	if !_rc {
		drop `var'
	}
}

tempfile OCCDAT
save `OCCDAT'

****************************************
*** CREATE FULL UNDEREMPLOYMENT DATA ***
****************************************

use "../intermediate/underemployment_data", clear

** PREPARE DATA **
keep if inlist(cln_educ_cat, "associates", "bachelors", "masters")
keep bls_occ cln_educ_cat educ_re* agedum* incwage perwt

** COUNTS OF OVEREDUCATION **
unab AGEDUMS: agedum_*

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
	merge m:1 bls educ_req educ_req_nbr age_cat using `OCCDAT'
		assert _merge != 1
		keep if _merge == 3
		drop _merge
	
	* Clean education variable
	replace cln_educ_cat = "aa" if cln_ed == "associates"
	replace cln_educ_cat = "ba" if cln_ed == "bachelors"
	replace cln_educ_cat = "ma" if cln_ed == "masters"

	* Overeducation premium flag
	gen premium = 0
		* HS "required" jobs
		replace premium = perwt if educ_req_nbr == 2 & ///
		 cln_ed == "aa" & incwage > $AA_PREM1 * med_wage_bls_educ
		replace premium = perwt if educ_req_nbr == 2 & ///
		 cln_ed == "ba" & incwage > $BA_PREM1 * med_wage_bls_educ
		replace premium = perwt if educ_req_nbr == 2 & ///
		 cln_ed == "ma" & incwage > $MA_PREM1 * med_wage_bls_educ
		* AA "required" jobs
		replace premium = perwt if educ_req_nbr == 4 & ///
		 cln_ed == "ba" & incwage > $BA_PREM2 * med_wage_bls_educ
		replace premium = perwt if educ_req_nbr == 4 & ///
		 cln_ed == "ma" & incwage > $MA_PREM2 * med_wage_bls_educ
		* BA "required" jobs
		replace premium = perwt if educ_req_nbr == 5 & ///
		 cln_ed == "ma" & incwage > $MA_PREM3 * med_wage_bls_educ
		 
	* Collapse data
	collapse (sum) individ_prem_ = premium, ///
	 by(age_cat bls_occ cln_educ_cat educ_re*)
	 
	* Reshape wide
	reshape wide individ_prem_, i(bls age_cat educ_re*) j(cln_educ_cat) string
	
	* save data
	tempfile PREM_`var'
	save `PREM_`var''
restore
}

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
use `OCCDAT', clear
	merge 1:1 bls_occ_title age_cat using `premdat', keep(3)
	drop _merge

local CAT "aa ba ma"
foreach x in `CAT' {
	replace individ_prem_`x' = 0 if mi(individ_prem_`x') | suff_`x' == 0
}

gen occ_count = 1

order age_cat bls occ_soc educ_* occ_count suff_* n_raw* n_wtd* ///
 comp_wage med_wage* prem_* individ_prem*
 gsort age_cat educ_req_nbr
 
** EXPORT DATA ***
save "../intermediate/premium_data", replace

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("premium_data", replace)
