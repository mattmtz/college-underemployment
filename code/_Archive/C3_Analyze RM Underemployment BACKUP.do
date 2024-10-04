/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ALT UNDEREMP DEFS
*** DATE:    07/01/2024
********************************/

use "../intermediate/clean_acs_data", clear
	keep if ft == 1

*********************************************
*** FIND BASELINE SHARE OF BA+ IN ECONOMY ***
*********************************************

preserve
	keep if agedum_25_54 == 1
	collapse (sum) perwt, by(postsec)
		
	gen id = "total"
	reshape wide perwt, i(id) j(postsec)
		
	assert _N == 1
		
	gen pct = perwt1 / (perwt0 + perwt1)
		
	local COMP_PCT = pct[1]
	di `COMP_PCT'
restore
	
*********************************
*** PREPARE DATA BY AGE GROUP ***
*********************************

** COUNTS BY AGE GROUP & POSTSECONDARY DEGREE **
unab AGEDUMS: agedum_*

foreach var of varlist `AGEDUMS' {
	
	/* FIND BA & BA+ LEVELS BY OCCUPATION */
	preserve
		keep if `var' == 1
		
		gen ba_workers = perwt
			replace ba_workers = 0 if cln_educ_cat != "bachelors"
		
		collapse (sum) ba_workers perwt, by(occ_soc bls_occ_title postsec)
		
		bysort occ_soc: egen tot_bas = max(ba_workers)
			drop ba_workers
		
		reshape wide perwt, i(occ bls tot_bas) j(postsec)
		rename (perwt0 perwt1) (less_ba ba_plus)
		
		replace less_ba = 0 if mi(less_ba)
		replace ba_plus = 0 if mi(ba_plus)
		
		gen pct_ba_plus = ba_plus / (less_ba + ba_plus)
			gen college_level_job = (pct_ba_plus > `COMP_PCT')
		
		gen majority_ba_plus = (ba_plus > less_ba)
		
		gen age_cat = "`var'"
		tempfile RM_`var'
		save `RM_`var''
	restore
	
}

*****************************
*** PREPARE FINAL DATASET ***
*****************************

** COMBINE INDIVIDUAL DATASETS **
clear
tempfile countsdat
save `countsdat', emptyok
count
foreach x in `AGEDUMS' {
	append using `RM_`x''
	save `"`countsdat'"', replace
} 

replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
replace age_cat = "all_workers" if age_cat == "all"

** CALCULATE UNDEREMPLOYMENT BY DEFINITION & AGE GROUP **
collapse (sum) tot_bas, by(age_cat college majority)

gen underemp_indicator = college + majority
	drop college majority

reshape wide tot_bas, i(age_cat) j(underemp)
	rename (tot_bas0 tot_bas1 tot_bas2) (less_ba ba_comp ba_majority)
	gen tot_bas = less_ba + ba_comp + ba_majority
	
gen underemp_by_comp = less_ba / tot_bas
gen underemp_by_maj = (less_ba + ba_comp) / tot_bas
gen diff = underemp_by_maj - underemp_by_com

**********************
*** CREATE FIGURES ***
**********************

** 22-23 & 25-54 **
graph bar underemp_by_comp diff if inlist(age_cat, "22-23", "22-27", "25-54"), ///
 over(age_cat, gap(*1.5)) stack ytitle("Share of underemployed BAs") ///
 ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") yscale(titlegap(*6)) ///
 legend(order(2 "In occupations with less than majority BA+" 1 ///
 "In occupations with less than baseline BA+ share") rows(2)) name(left, replace)

/*
graph bar underemp_by_comp diff if !inlist(age_cat, "25-54", "all_workers"), ///
 over(age_cat) stack ytitle("Share of underemployed BAs") ///
 ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
 legend(order(2 "In occupations with less than majority BA+" 1 ///
 "In occupations with less than baseline BA+ share") rows(2)) name(right)
*/

** 5-YEAR AGE BANDS **
graph bar underemp_by_comp diff if !inlist(age_cat, "22-27", "25-54", ///
 "all_workers"), over(age_cat) stack ytitle("") yscale(off) graphregion(margin(r=10)) ///
 legend(order(2 "In occupations with less than majority BA+" 1 ///
 "In occupations with less than baseline BA+ share") rows(2)) name(right, replace)

graph combine left right, ycommon ///
 note("Baseline BA+ share in economy is 43%, based on 25-54-year-old FTFY workers.")
graph export "output/RM_underemp_by_age.png", width(3000) height(1500) replace 
