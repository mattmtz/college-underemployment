/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ALT UNDEREMP DEFS
*** DATE:    07/01/2024
********************************/

use "../intermediate/clean_acs_data", clear
	keep if ft == 1 & agedum_25_54 == 1
	
gen educ_cat = "hs_or_less"
	replace educ_cat = "aa/some college" if inlist(cln_educ_cat_nbr, 3, 4)
	replace educ_cat = "ba+" if cln_educ_cat_nbr > 4

******************************
*** IDENTIFY RM CATEGORIES ***
******************************

preserve
	** COLLAPSE DATA **
	collapse (sum) perwt, by(occ_acs occ_soc bls_occ_title educ_cat postsec_deg)
		bysort occ_acs occ_soc bls: egen tot = sum(perwt)
		gen pct = perwt / tot
		bysort occ_* bls: egen maxpct = max(pct)
		
		gen ba_plus_pct_int = 0
			replace ba_plus_pct_int = pct if educ_cat == "ba+"
			bysort occ_* bls: egen ba_plus_pct = max(ba_plus_pct_int)
			drop ba_plus_pct_int
		
	** PLURALITY DEFINITION **
	gen plurality_int = 0
		replace plurality_int = 1 if pct == maxpct & educ_cat == "ba+"
		bysort occ_* bls: egen college_occ_plurality = max(plurality_int)
		drop plurality_int

	** MAJORITY DEFINITION **
	collapse (sum) pct, by(occ_acs occ_soc bls_occ college_occ_pl ba_plus_pct postsec)
	
	gen majority_int = 0
		replace majority_int = 1 if pct > 0.5 & postsec_deg == 1
		bysort occ_* bls: egen college_occ_majority = max(majority_int)
		drop majority_int
		
	keep occ* bls college_occ* ba_plus_pct
	duplicates drop
	
	tempfile COLLEGEOCCS
	save `COLLEGEOCCS'
restore

merge m:1 occ_acs occ_soc bls_occ_title using `COLLEGEOCCS'
	assert _merge == 3
	drop _merge

*************************************
*** CALCULATE COMPARISON EARNINGS ***
*************************************

preserve
	keep if cln_educ_cat_nbr < 5
	collapse (p50) comp_wage = incwage [pw = perwt], by(occ_soc occ_acs bls_occ)
	tempfile LOWAGE
	save `LOWAGE'
restore

merge m:1 occ_acs occ_soc bls_occ using `LOWAGE', keep(1 3) nogen
	keep if cln_educ_cat == "bachelors"
keep occ_acs occ_soc bls_occ college_occ* comp_wage ba_plus_pct incwage perwt

gen ba_prem = incwage / comp_wage - 1
	format ba_prem %5.2f

label define majority_lbl 0 "<BA+ occupations" 1 "BA+ occupations"
label values college_occ_maj majority_lbl
label values college_occ_pl majority_lbl

******************************************
*** ANALYZE DIFFERENCES BY RM CATEGORY ***
******************************************

tab college_oc*, row

** BA WAGES - KDENSITY **
twoway (kdensity incwage if college_occ_plur == 0 & incwage < 210000) ///
 (kdensity incwage if college_occ_plur == 1 & incwage < 210000), ///
 ylabel(0 "0" 0.000005 "0.5e-5" 0.00001 "1.0e-5" 0.000015 "1.5e-5" 0.00002 "2.0e-5")  ///
 legend(order(1 "<BA+ occupations" 2 "BA+ occupations")) ///
 xtitle("BA earnings (thousands of USD)") ytitle("Kernel Density") ///
 xlabel(0 "0" 50000 "50" 100000 "100" 150000 "150" 200000 "200") ///
 title("BA earnings by RM category (Plurality)") note("Earnings truncated above $210k/yr.") ///
 name(left, replace)
 
twoway (kdensity incwage if college_occ_maj == 0 & incwage < 210000) ///
 (kdensity incwage if college_occ_maj == 1 & incwage < 210000), ///
 ysc(off) ytitle("") legend(order(1 "<BA+ occupations" 2 "BA+ occupations")) ///
 xtitle("BA earnings (thousands of USD)") ytitle("Kernel Density") ///
 xlabel(0 "0" 50000 "50" 100000 "100" 150000 "150" 200000 "200") ///
 title("BA earnings by RM category (Majority)") note("Earnings truncated above $210k/yr.") ///
 name(right, replace)
 
graph combine left right, ycommon
graph export "output/RM_earnings_kdensities_by_definition.png", width(2800) height(1100) replace
 
** BA WAGES -- BOX PLOTS **
graph box incwage, over(college_occ_p) noout title("BA earnings by RM category (plurality)") ///
 ylabel(0 "0" 50000 "50" 100000 "100" 150000 "150" 200000 "200") ///
 ytitle("BA earnings (thousands of USD)") name(left, replace)

graph box incwage, over(college_occ_m) noout title("BA earnings by RM category (majority)") ///
 ysc(off) ytitle("") name(right, replace)

graph combine left right, ycommon
graph export "output/RM_earnings_boxplots_by_definition.png", width(2500) height(1100) replace
 
** BA WAGES -- TABLES **
tabstat incwage, by(college_occ_plural) stat(p25 p50 mean p75) nototal format(%10.0fc)
tabstat incwage, by(college_occ_maj) stat(p25 p50 mean p75) nototal format(%10.0fc)

** BA PREMIUM **
graph box ba_prem, over(college_occ_pl) noout ytitle("BA premium") ///
 ylabel(-1(0.5)3, format(%3.1f)) title("BA premium over <BA workers by RM categorization")
 
tabstat ba_prem, by(college_occ_pl) stat(p25 p50 mean p75) nototal format
tabstat ba_prem, by(college_occ_maj) stat(p25 p50 mean p75) nototal format

preserve
collapse (median) ba_prem ba_plus_pct [pw = perwt], by(occ_acs occ_soc college_oc*)
	save "../intermediate/rm_data", replace

twoway (scatter ba_prem ba_plus, msize(small)) ///
 (lfit ba_prem ba_plus if college_occ_plurality == 0, lwidth(thick)) ///
 (lfit ba_prem ba_plus if college_occ_p == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(order(2 "Fitted line (<BA occs)" 3 "Fitted line (BA+ occs)")) ///
 ytitle("Occupational median premium") xtitle("BA+ share of workers") ///
 ylabel(0 "0%" .5 "50%" 1 "100%" 1.5 "150%" 2 "200%") graphregion(margin(r=1)) ///
 title("Median BA premium by RM category (plurality)") yscale(titlegap(*6)) ///
 name(left, replace)
 
graph export "output/RM_plurality_occs_BA_premiums.png", width(2500) height(1500) replace

twoway (scatter ba_prem ba_plus, msize(small)) ///
 (lfit ba_prem ba_plus if college_occ_maj == 0, lwidth(thick)) ///
 (lfit ba_prem ba_plus if college_occ_m == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(order(2 "Fitted line (<BA occs)" 3 "Fitted line (BA+ occs)")) ///
 ysc(off) ytitle("") xtitle("BA+ share of workers") graphregion(margin(r=10)) ///
 title("Median BA premium by RM category (majority)") name(right, replace)
 
graph combine left right, ycommon
graph export "output/RM_occs_by_baplus_shares_and_defs.png", width(2500) height(1100) replace
 
twoway (scatter ba_prem ba_plus, msize(small)) ///
 (lfit ba_prem ba_plus if college_occ_majority == 0, lwidth(thick)) ///
 (lfit ba_prem ba_plus if college_occ_m == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(order(2 "Fitted line (<BA occs)" 3 "Fitted line (BA+ occs)")) ///
 ytitle("Occupational median premium") xtitle("BA+ share of workers") ///
 ylabel(0 "0%" .5 "50%" 1 "100%" 1.5 "150%" 2 "200%") graphregion(margin(r=1)) ///
 title("Median BA premium by RM category (majority)") yscale(titlegap(*6)) ///
 name(left, replace)
graph export "output/RM_majority_occs_BA_premiums.png", width(2500) height(1500) replace

restore
