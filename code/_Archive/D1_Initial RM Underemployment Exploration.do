/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ALT UNDEREMP DEFS
*** DATE:    07/01/2024
********************************/

use "../intermediate/clean_acs_data", clear
	keep if ft == 1
	gen educ_group = cln_educ_cat
		replace educ_group = "other_lo" if inlist(cln_educ_cat_nbr, 1, 3, 4)
		replace educ_group = "other_hi" if inlist(cln_educ_cat_nbr, 6, 7)

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
		
		gen n_workers = 1
		
		* Collapse data to key categories
		collapse (sum) n_workers (median) incwage [pw = perwt], ///
		 by(occ_acs occ_soc bls_occ_title educ_group postsec)
		 
		* Get HS/BA wages by occupation
		gen hs_wage_int = 0
			replace hs_wage_int = incwage if educ_group == "hs"
			bysort occ_acs occ_soc bls: egen hs_wage = max(hs_wage_int)
			
		gen ba_wage_int = 0
			replace ba_wage_int = incwage if educ_group == "bachelors"
			bysort occ_acs occ_soc bls: egen ba_wage = max(ba_wage_int)
			
		drop *_wage_int incwage
		
		* Collapse total & BA workers by postsecondary degree status
		gen ba_workers = n_workers if educ_group == "bachelors"
			replace ba_workers = 0 if mi(ba_workers)
			
		gen hs_workers = n_workers if educ_group == "hs"
			replace hs_workers = 0 if mi(hs_workers)
			
		collapse (sum) *_workers, by(occ_acs occ_soc bls_occ postsec *_wage)
		
		bysort occ_acs occ_soc: egen tot_bas = max(ba_workers)
			drop ba_workers
			
		bysort occ_acs occ_soc: egen tot_hs = max(hs_workers)
			drop hs_workers
		
		reshape wide n_workers, i(occ* bls tot_* *_wage) j(postsec)
		rename (n_workers0 n_workers1) (less_ba ba_plus)
		
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
replace age_cat = "all_workers" if age_cat == "all"

*******************************************
*** CHECK BA PREMIUM IN KEY OCCUPATIONS ***
*******************************************

preserve
	keep if college_level == 1 & majority_ba == 0 // 25 occupations for 25-54
	gen ba_premium = ba_wage / hs_wage - 1
	
	bysort age: sum ba_prem if tot_bas < $NFLAG | tot_hs < $NFLAG , d
	keep if tot_bas >= $NFLAG & tot_hs >= $NFLAG // 3 occs in 22-23, 1 in 40-45, 1 in 55-64
	
** 22-27 MEDIAN PREMIUM **
levelsof age_cat, local(AGE_CAT)
foreach x of local AGE_CAT {
	sum ba_prem if age_cat == "`x'", d
	local RGS_val_`x' = `r(p50)'
	local RGS_`x' : di %5.1f 100*`r(p50)'
	di `RGS_`x''
	di "`RGS_`x''%"
}

replace age_cat = subinstr(age_cat, "_", "-", .)
*bysort age_cat: count if inlist(age_cat, "22-27", "25-34", "25-54")
graph hbox ba_prem if inlist(age_cat, "22-27", "25-34", "25-54"), over(age_cat) ///
 text(`RGS_val_22_27' 99 "`RGS_22_27'%" 62 `RGS_val_25_34' "`RGS_25_34'%" ///
 25 `RGS_val_25_54' "`RGS_25_54'%") ylabel(-0.4 "-40%" -0.2 "-20%" 0 "0%" .2 ///
  "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%" 1.2 "120%") ytitle("BA premium") ///
  note("Medians reported above box plots. In descending order: 28, 20, and 25 occupations considered.") ///
  title("BA premium over HS workers by age group")
restore
**********************
*** CREATE FIGURES ***
**********************
replace age_cat = subinstr(age_cat, "_", "-", .)

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
