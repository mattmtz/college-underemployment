/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE MAIN DATASET
*** DATE:    05/20/2024
********************************/

use "../intermediate/underemployment_data", clear

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
		collapse (p50) mwage=incwage (mean) avgwage=incwage [pw = perwt], ///
		 by(bls occ_soc educ_re* agg_educ)
	
		reshape wide mwage avgwage, i(bls occ_soc educ_*) j(agg_educ_lvl) 
		rename (mwage0 mwage1 mwage2) ///
		(u_md mwage_bls_educ mwage_overeduc)
		rename (avgwage0 avgwage1 avgwage2) ///
		(u_mn avgwage_bls_educ avgwage_overeduc)
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
		collapse (p50) mwage = incwage [pw = perwt], by(educ_req)
	
		gen cln_educ_cat = "all_workers"
		gen age_cat = "`var'"
		tempfile T_`var'
		save `T_`var''
	restore

	** BY DETAILED EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) mwage = incwage [pw = perwt], by(cln_educ_cat educ_req)
		
		gen age_cat = "`var'"
		tempfile D_`var'
		save `D_`var''
	restore

	** BY AGGREGATE EDUCATION **
	preserve
		keep if `var' == 1
		collapse (p50) mwage = incwage [pw = perwt], by(postsec_deg educ_req)

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

replace bls_occ_title = "All occupations requiring " + strlower(educ_req) ///
 if bls_occ_title == ""
 
** ADD KEY VARIABLES **
gen mwage_educ_diff = mwage_over - mwage_bls
gen avgwage_educ_diff = avgwage_over - avgwage_bls
gen avg_educ_premium = avgwage_over / avgwage_bls - 1
gen med_educ_premium = mwage_over / mwage_bls - 1
gen avg_premium_flag = (avg_educ_pr > $OVEREDUC_PREMIUM )
	replace avg_premium_flag = 0 if mi(avgwage_over) | mi(avgwage_bls)
gen med_premium_flag = (med_educ_pr > $OVEREDUC_PREMIUM )
	replace med_premium_flag = 0 if mi(mwage_over) | mi(mwage_bls)
** EXPORT DATA **
order age_cat bls_occ_title occ_soc educ_req_nbr educ_req cln_educ_cat ///
 mwage* med_premium med_educ avg* 
gsort age_cat educ_req_nbr bls_occ_title

save "../intermediate/data_by_educ_req", replace
