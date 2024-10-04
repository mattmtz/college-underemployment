/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ALT UNDEREMP DEFS
*** DATE:    07/01/2024
********************************/

**************************
*** RM UNDEREMPLOYMENT ***
**************************

use "../intermediate/clean_acs_data", clear
	keep if ft == 1
	drop agedum_all

** COUNTS BY AGE GROUP & POSTSECONDARY DEGREE **
unab AGEDUMS: agedum_*

foreach var of varlist `AGEDUMS' {

	preserve
		keep if `var' == 1
		
		gen postsec_workers = perwt
			replace postsec_workers = 0 if postsec_degree_dum == 0
		
		gen ba_workers = perwt
			replace ba_workers = 0 if cln_educ_cat != "bachelors"
		
		gen educ_group = "ba+" if postsec_degree_dum == 1
			replace educ_group = "hs_or_less" if inlist(cln_educ_cat, "hs", "less_hs")
			replace educ_group = "aa/some_college" if mi(educ_group)
		
		collapse (sum) *_workers perwt, by(occ_soc bls_occ_title educ_group)
		
		bysort occ_soc bls_occ: egen tot_workers = sum(perwt)
		bysort occ_soc bls_occ: egen tot_postsec = max(postsec_workers)
		bysort occ_soc bls_occ: egen tot_ba = max(ba_workers)
			drop ba_workers postsec_workers
		
		gen postsec_pct = tot_postsec / tot_workers 
			gen ba_majority = (postsec_pct > 0.5)
		
		bysort occ_soc bls: egen max_group = max(perwt)
		gen int_ba_plurality = 0
			replace int_ba_pl = 1 if educ_group == "ba+" & perwt == max_group
			bysort occ_soc bls: egen ba_plurality = max(int_ba_plurality)
			drop int_ba_plurality

		keep occ_soc bls_occ_title ba_plurality ba_majority tot_ba
		duplicates drop
		
		gen age_cat = "`var'"
		tempfile RM_`var'
		save `RM_`var''
	restore
	
}

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

** CALCULATE UNDEREMPLOYMENT **
collapse (sum) tot_ba, by(age_cat ba_plurality ba_majority)
	gen ba_sum = ba_p + ba_m // 0 = ba minority; 1 = ba plurality; 2 = ba majority
	drop ba_p ba_m

reshape wide tot_ba, i(age_cat) j(ba_sum)
	gen underemp_rm_plurality = tot_ba0 / (tot_ba0 + tot_ba1 + tot_ba2)
	gen underemp_rm_majority = (tot_ba0+tot_ba1) / (tot_ba0 + tot_ba1 + tot_ba2)
	
** SAVE DATA **
keep age_cat underemp_r*
tempfile RM_UNDEREMP
save `RM_UNDEREMP'

********************************
*** OER & EP UNDEREMPLOYMENT ***
********************************

*** LOAD DATA ***
use "../intermediate/underemployment_data", clear
	drop if bls_occ_title == "All occupations" | cln_educ_cat != "bachelors"
	drop if ftfy == 0 | inlist(age_cat, "55-64", "all_workers")
	 
*** CREATE COUNTS FOR UNDEREMPLOYMENT ***
gen n_suff = n_wtd
	replace n_suff = 0 if suff_flag == 0

collapse (sum) n_wtd n_suff underemp_bls underemp, by(age_cat)
	gen underemp_oer = underemp_bls / n_wtd
	gen underemp_ep = underemp / n_suff
	drop n_wtd n_suff underemp underemp_bls

**********************
*** CREATE FIGURES ***
**********************

** SET UP DATA **
merge 1:1 age_cat using `RM_UNDEREMP', nogen
merge 1:1 age_cat using "../intermediate/deming_underemployment", nogen

reshape long underemp_, i(age_cat) j(definition) string
	rename underemp_ underemp
	
** CREATE FIGURE **
replace underemp = underemp * 100

gen order = 1 if def == "oer"
	replace order = 2 if def == "rm_majority"
	replace order = 3 if def == "deming"
	replace order = 4 if def == "rm_plurality"
	replace order = 5 if def == "ep"
	
graph bar underemp if inlist(age_cat, "22-27", "28-33", "34-39", "40-45"), ///
 over(def, sort(order)) over(age_cat) asyvars blabel(bar, format(%4.1f) size(vsmall)) ///
 legend(order(3 "OER" 4 "RM (Maj)" 1 "Deming" 5 "RM (Plur)" 2 "EP") rows(1)) ///
 ytitle("Underemployment (%)") yscale(titlegap(*20)) ///
 title("Underemployment by definition & age group")

graph export "output/alt_underemp_5yrs.png", width(3000) height(2200) replace 

graph bar underemp if age_cat == "25-54", over(def, sort(order)) asyvars ///
 blabel(bar, format(%4.1f)) ytitle("Underemployment (%)") ysc(titlegap(*20)) ///
 legend(order(3 "OER" 4 "RM (Maj)" 1 "Deming" 5 "RM (Plur)" 2 "EP") rows(1)) ///
 title("Underemployment by definition (25-54)")
 
graph export "output/alt_underemp_25_54.png", width(3000) height(2200) replace 
