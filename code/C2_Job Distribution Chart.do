/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: OCC DISTRIBUTIONS
*** DATE:    07/01/2024
********************************/

*******************************
*** CREATE OCC SHARES GRAPH ***
*******************************

use "../intermediate/data_by_occ_wide", clear

*** KEEP VARIABLES OF INTEREST ***
keep age_cat bls_occ_title educ_re* *_hs *_associates *_bachelors *_masters
drop avg_wag* *_less_hs

*** CREATE AGGREGATE EDUCATION CATEGORIES ***
gen agg_educ_req = educ_req
	replace agg_educ = "Other" if inlist(educ_req_nbr, 3, 3.5)
	replace agg_educ = "MA+" if inlist(educ_req_nbr, 6, 7)

*** WAGES BY EDUCATION LEVEL AND EDUCATION REQUIREMENT ***
local CAT "hs associates bachelors masters"
foreach x in `CAT' {
	replace med_wage_`x' = . if suff_`x' == 0
}

collapse (sum) nwtd* (p50) mwage_hs = med_wage_hs mwage_aa = med_wage_a ///
 mwage_ba = med_wage_ba mwage_ma = med_wage_ma, by(age_cat agg_educ)

*** EXPORT DATA ***
replace agg_educ = "All workers" if mi(agg_educ)

order age_cat agg_ed nwtd_hs nwtd_* mwage_*
export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("distributions", replace)
 
*******************************
*** CREATE OCC SHARES GRAPH ***
*******************************

use "../intermediate/underemployment_data", clear

*** KEEP VARIABLES OF INTEREST ***
keep agedum* educ_re* cln_educ_cat incwage perwt

*** CREATE AGGREGATE EDUCATION CATEGORIES ***
gen agg_educ_req = educ_req
	replace agg_educ = "Other" if inlist(educ_req_nbr, 3, 3.5)
	replace agg_educ = "MA+" if inlist(educ_req_nbr, 6, 7)

*** COLLAPSE DATA ***
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

foreach var of varlist `AGEDUMS' {

preserve 
	keep if `var' == 1

	collapse (p10) wage_p10 = incw (p25) wage_p25 = incw ///
	(p50) wage_p50 = incw (p75) wage_p75 = incw (p90) wage_p90 = incw ///
	[pw = perwt], by(agg_educ cln_educ_cat)
	
	gen age_cat = "`var'"
	tempfile T_`var'
	save `T_`var''
restore
}

clear
tempfile wagedat
save `wagedat', emptyok

foreach x in `AGEDUMS' {
	append using `T_`x''
	save `"`wagedat'"', replace
}

** CLEAN DATASET **
replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
replace age_cat = "all_workers" if age_cat == "all"

** EXPORT DATASET **
order age_cat agg_educ_req cln_educ_cat wage*
gsort age_cat agg_educ_req cln_educ_cat

export excel using "output/summary_tables.xlsx", ///
 first(var) sheet("distributions", replace)

**********************************
*** CREATE WAGE DENSITY GRAPHS ***
**********************************

use "../intermediate/underemployment_data", clear

*** KEEP ONLY BA HOLDERS IN HS- OR BA- LEVEL JOBS ***
keep if inlist(educ_req_nbr, 2, 5) & cln_educ_cat == "bachelors"

*** KDENSITY ***
twoway (kdens incwage if educ_req_nbr == 2 [pw=perwt], ra(0 150000)) ///
 (kdens incwage if educ_req_nbr == 5 [pw=perwt], ra(0 150000)), ///
  legend(order(1 "HS wages" 2 "BA wages"))
