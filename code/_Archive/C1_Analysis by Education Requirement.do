/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: OCC DISTRIBUTIONS
*** DATE:    07/12/2024
********************************/

*******************************
*** CREATE OCC SHARES GRAPH ***
*******************************

use "../intermediate/clean_acs_data", clear
	keep if ft == 1

*** KEEP VARIABLES OF INTEREST ***
keep agedum* educ_re* cln_educ_cat incwage perwt

*** CREATE AGGREGATE EDUCATION CATEGORIES ***
gen agg_educ_req = educ_req
	replace agg_educ = "AA/Other" if inlist(educ_req_nbr, 3, 4)
	replace agg_educ = "MA+" if inlist(educ_req_nbr, 6, 7)

*** COLLAPSE BY EDUCATION & REQUIREMENT ***
unab AGEDUMS: agedum_*
di "`AGEDUMS'"

foreach var of varlist `AGEDUMS' {

preserve 
	keep if `var' == 1

	collapse (p10) wage_p10 = incw (p25) wage_p25 = incw ///
	(p50) wage_p50 = incw (p75) wage_p75 = incw (p90) wage_p90 = incw ///
	[pw = perwt], by(agg_educ cln_educ_cat)
	
	gen age_cat = "`var'"
	tempfile EDREQ_`var'
	save `EDREQ_`var''
restore
}

*** COMBINE DATA ***
clear
tempfile wagedat
save `wagedat', emptyok

foreach x in `AGEDUMS' {
	append using `EDREQ_`x''
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

use "../intermediate/clean_acs_data", clear

*** KEEP ONLY FT BA HOLDERS IN HS- OR BA- LEVEL JOBS ***
keep if inlist(educ_req_nbr, 2, 5) & cln_educ_cat == "bachelors" & ///
 agedum_25_54==1 & ft == 1

*** KDENSITY ***
twoway (kdens incwage if educ_req_nbr == 2 [pw=perwt], ra(0 160000)) ///
 (kdens incwage if educ_req_nbr == 5 [pw=perwt], ra(0 160000)), ///
  legend(order(1 "HS-level occupations" 2 "BA-level occupations")) ///
  title("Wages for college-educated workers aged 25-54" "by BLS occupation category") /// 
  xtitle("Earnings (dollars)") ytitle("Density") xlabel(,format(%9.0gc)) ///
  ylabel(0 "0%" .000005 ".0005%"  .00001 ".0010%" .000015 ".0015%")

graph export "output/ba_wage_dist_by_bls_educ_req.png", replace

*** PREMIUM DISTRIBUTIONS ***
keep if educ_req_nbr == 2
preserve
	use "../intermediate/data_by_occ", clear
	keep if age_cat == "25-54" & educ_req_nbr == 2 & suff_flag == 1 & ///
	 cln_educ_cat == "bachelors" & ft == 1
	keep bls comp_wage
	tempfile OCCDAT
	save `OCCDAT'
restore

merge m:1 bls using `OCCDAT', keep(3)

gen premium = incwage/comp_wage - 1

gen age_cat = "25-34"
	replace age_cat = "35-44" if age > 34 & age <= 45
	replace age_cat = "45-54" if age > 44 & age <= 55
	replace age_cat = "55-64" if age > 54

graph box premium [pw = perwt], over(age_cat) nooutsides
