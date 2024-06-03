/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE MAIN DATASET
*** DATE:    05/20/2024
********************************/

*************
*** SETUP ***
*************
clear
capture log close
set more off

** SET WORKING DIRECTORY **
cd "C:\Users\mattm\Dropbox\GWU\03_Summer Work\Research Analyst\"
cd "Georgetown\Underemployment Project"

use "C:\Users\mattm\OneDrive\Desktop\IPUMS Data\underemployment_data", clear

** CREATE AGGREGATE EDUCATION GROUPS **
gen agg_educ_lvl = 0 if cln_educ_cat_nbr < educ_req_nbr
	replace agg_educ_lvl = 1 if cln_educ_cat_nbr == educ_req_nbr
	replace agg_educ_lvl = 2 if cln_educ_cat_nbr > educ_req_nbr

** CREATE LOCAL WITH AGE DUMMIES **
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

****************************************************************
*** OCCUPATIONAL EARNINGS BASED ON RELATIVE EDUCATION LEVELS ***
****************************************************************

foreach var of varlist `AGEDUMS' {

	preserve
		keep if `var'==1
		** DROP UNUSABLE EDUC REQ CATEGORIES **
		drop if inlist(educ_req_nbr, 3.5, 7)
		
		** COLLAPSE DATA **
		collapse (p50) md_wage=incwage (mean) avg_wage=incwage [pw = perwt], ///
		 by(bls occ_soc educ_re* agg_educ)
	
		reshape wide md_wage avg_wage, i(bls occ_soc educ_*) j(agg_educ_lvl) 
		rename (md_wage0 md_wage1 md_wage2) ///
		(u_md md_bls_educ_wage md_overeduc_wage)
		rename (avg_wage0 avg_wage1 avg_wage2) ///
		(u_mn avg_bls_educ_wage avg_overeduc_wage)
		drop u_*
	
		gen age_cat = "`var'"
		tempfile Occ_`var'
		save `Occ_`var''
	restore
}

************************************************************
*** EARNINGS BY AGE AND AGGREGATE EDUCATION REQUIREMENTS ***
************************************************************

foreach var of varlist `AGEDUMS' {

	** ALL WORKERS **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(educ_req)
	
		gen bls_occ_title = "All Occupations"
		gen cln_educ_cat = "all_workers"
		gen age_cat = "`var'"
		tempfile T_`var'
		save `T_`var''
	restore

	** BY DETAILED EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(cln_educ_cat educ_req)
		
		gen bls_occ_title = "All Occupations"
		gen age_cat = "`var'"
		tempfile D_`var'
		save `D_`var''
	restore

	** BY AGGREGATE EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) med_wage = incwage [pw = perwt], by(postsec_deg educ_req)
	
		gen cln_educ_cat = "BA+" if postsec == 1
			replace cln_educ_cat = "less_BA" if postsec==0
			drop postsec
		gen age_cat = "`var'"

		tempfile A_`var'
		save `A_`var''
	restore
}

****************************
*** CREATE FINAL DATASET ***
****************************

clear

tempfile fulldat
save `fulldat', emptyok
count
foreach x in `AGEDUMS' {
	append using `Occ_`x''
	append using `T_`x''
    append using `D_`x''
	append using `A_`x''
	save `"`fulldat'"', replace
} 

use `fulldat', clear

** CLEAN DATASET **
replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
replace age_cat = "all_workers" if age_cat == "all"

replace bls_occ_title = "All Occupations" if bls_occ_title == ""

** EXPORT DATA **
order age_cat bls_occ_title occ_soc educ_req_nbr educ_req cln_educ_cat ///
 med_wage md* avg* 
gsort age_cat educ_req_nbr bls_occ_title

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("data_by_req", replace)
 