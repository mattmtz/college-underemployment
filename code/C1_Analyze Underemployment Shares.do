/**************************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE MEMO FIGURES
*** DATE:    07/17/2024
**************************************/

*** LOAD DATA ***
use "../intermediate/underemployment_data", clear
	drop if bls_occ_title == "All occupations" | cln_educ_cat != "bachelors"
	 
*** CREATE COUNTS FOR UNDEREMPLOYMENT ***
gen n_suff = n_wtd
	replace n_suff = 0 if suff_flag == 0

****************************
*** CREATE FIGURE 1 DATA ***
****************************

*** UNDEREMPLOYMENT BY DEFINITION (FTFY WORKERS ONLY) ***
preserve
	drop if ftfy == 0
	collapse (sum) n_wtd n_suff underemp_bls underemp, by(age_cat)
	gen ftfy = "FTFY only"
	gen pct_underemp_bls = underemp_bls / n_wtd
	gen pct_underemp = underemp / n_suff
	
	tempfile FTFY
	save `FTFY'
restore

*** BLS UNDEREMPLOYMENT (ALL WORKERS) ***
preserve
	collapse (sum) n_wtd underemp_bls, by(age_cat)
	gen ftfy = "All workers"
	gen pct_underemp_bls = underemp_bls / n
	gen n_suff = .
	gen underemp = .
	
	append using `FTFY'
	
	keep age_cat ftfy pct*
	order age_cat ftfy pct_underemp_bls pct_underemp
	gsort -ftfy age_cat
	
	export excel using "$FILE", first(var) sheet("fig1_raw", replace)
restore 

****************************
*** CREATE FIGURE 2 DATA ***
****************************

keep if age_cat == "25-54" & ftfy == 1
gen below_ba_lvl = (educ_req_nbr < 5)
	keep if below_ba == 1

collapse (sum) n_wtd n_suff underemp_bls underemp, by(below_ba)
	
gen pct_underemp_bls = underemp_bls / n_wtd
gen pct_underemp = underemp / n_suff
	
keep below_ba pct*
order below pct_underemp_bls pct_underemp
	
export excel using "$FILE", first(var) sheet("fig3_raw", replace)

***************************
*** CREATE TABLE 1 DATA ***
***************************

*** LOAD DATA ***
use "../intermediate/clean_acs_data", clear

keep if agedum_25_54 == 1 & inlist(cln_educ_cat, "hs", "bachelors") & ///
 inlist(educ_req_nbr, 2, 5) & ftfy == 1
 
*** COLLAPSE DATA ***
collapse (p25) w_p25 = incw (p50) w_p50 = incw (p75) w_p75 = incw ///
 [pw = perwt], by(cln_educ_cat educ_req)
	
*** RESHAPE DATA ***
reshape long w_p, i(cln_educ_cat educ_r*) j(pctl)
reshape wide w_p, i(educ_req pctl) j(cln_educ_cat) string

*** EXPORT DATA ***
rename (w_pba w_phs) (ba_wage hs_wage)
tostring(pctl), replace

replace pctl = pctl + "th pctl"
replace educ_req = "BA" if strpos(educ_req, "Ba")
replace educ_req = "HS" if strpos(educ_req, "High")

order educ_req pctl hs_wage ba_wage
gsort -educ_req pctl

export excel using "$FILE", first(var) sheet("table1_raw", replace)
