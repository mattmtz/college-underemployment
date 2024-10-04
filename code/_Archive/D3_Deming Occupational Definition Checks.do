
***********************
*** PREPARE DATASET ***
***********************

*** PREPARE DEMING XWALK
import excel using "input/Deming_2017_TableA3.xlsx", sheet("Table A3") first clear
keep occ code_desc acs_2010
drop if mi(acs)

replace occ1990 = occ[_n-1] if mi(occ)
replace code = code[_n-1] if mi(code)

* See FN 24 of Deming (2023) "Why do Wages Grow Faster for Educated Workers?"
gen deming_cat = ""
	replace deming_cat = "other_professional" if occ > 22 & occ < 236
	replace deming_cat = "sales_admin_support" if occ > 242 & occ < 400
	replace deming_cat = "blue_collar" if occ >= 400
	replace deming_cat = "management" if occ > 3 & occ < 23
	replace deming_cat = "management" if inlist(occ, 243, 303, 413, 414, 415) | ///
	 inlist(occ, 433, 448, 450, 470, 503, 558, 628, 803, 823)

rename acs occ2010
keep occ2010 deming_cat
duplicates drop

tempfile DEMING
save `DEMING'

** MERGE INTO DATASET **
use "../intermediate/clean_acs_data", clear
	keep if cln_educ_cat == "bachelors"
	*keep if agedum_25_54 == 1
	*drop agedum*
	
merge m:1 occ2010 using `DEMING'

** FIX LARGEST MISSING CATEGORIES **
tab occ2010 if _merge == 1, sort
tab occ2010 if _merge == 1, nol sort

replace deming_cat = "other_professional" if occ2010 == 3130 // Registered nurses: occ == 95
replace deming_cat = "other_professional" if occ2010 == 1000 // Computer scientists: occ == 64
replace deming_cat = "management" if occ2010 == 30 // Managers in Marketing, Advert...: occ == 13
replace deming_cat = "management" if occ2010 == 130 // Human Resources Managers: occ == 8
replace deming_cat = "other_professional" if occ2010 == 2140 // Paralegals...: occ == 234
replace deming_cat = "blue_collar" if occ2010 == 9100 // Bus and Ambulance Drivers...: occ == 808
replace deming_cat = "other_professional" if occ2010 == 3530 // Health Technologists..." occ == 208
replace deming_cat = "other_professional" if occ2010 == 1830 // Urban/Regional Planners: occ == 173
replace deming_cat = "blue_collar" if occ2010 == 8230 // Bookbinders/Printing Machine...: occ == 734

gen mi_deming = (mi(deming_cat))
tab mi_deming // 94.95% match
drop mi_deming

keep if _merge == 3
drop _merge

*** DEFINE AGE GROUPS ***
gen group = "22-23" if age < 24
	replace group = "25-29" if age > 24 & age < 30
	replace group = "30-34" if age > 29 & age < 35
	replace group = "35-39" if age > 34 & age < 40
	replace group = "40-44" if age > 39 & age < 45
	replace group = "45-49" if age > 44 & age < 50
	replace group = "50-54" if age > 49 & age < 55
	replace group = "55-59" if age > 54 & age < 60
	replace group = "60-64" if age > 59

*******************************
*** CHECK OCC CHANGE BY AGE ***
*******************************

collapse (sum) perwt, by(group deming)

bysort group: egen tot = sum(perwt)
gen pct = 100* perwt / tot

drop perwt tot
reshape wide pct, i(group) j(deming_cat) string
rename (pctblue pctman pctoth pctsales) (blue_collar mgmt prof sales_admn)

encode group, gen(group_n)
twoway connected blue mgmt prof sales group_n, ytitle("Employment Share %") ///
 msymbol(sh Dh Oh Th) lcolor(navy black maroon green) mcolor(navy black maroon green) ///
 xlabel(1 "22-23" 2 "25-29" 3 "30-34" 4 "35-39" 5 "40-44" 6 "45-49" 7 "50-54" ///
 8 "55-59" 9 "60-64") xtitle("Age group")

** COLLAPSE DATA **
preserve
	collapse (sum) perwt, by(educ_req cln_educ_cat deming)
	tempfile COUNTS
	save `COUNTS'
restore

collapse (p50) incwage [pw = perwt], by(educ_req cln_educ_cat deming)
	merge 1:1 educ_req cln_educ deming using `COUNTS', nogen
	
keep if strpos(educ_req, "High school") & inlist(cln_educ_cat, "hs", "bachelors")
