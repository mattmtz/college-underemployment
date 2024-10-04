/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: DEMING UNDEREMPLOYMENT
*** DATE:    07/01/2024
********************************/

****************************
*** PREPARE DEMING XWALK ***
****************************

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
	keep if cln_educ_cat == "bachelors" & ftfy == 1
	drop agedum_55_64 agedum_all
	
merge m:1 occ2010 using `DEMING'

*********************
*** CLEAN DATASET ***
*********************

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
tab mi_deming // 94.85% match
drop mi_deming

keep if _merge == 3
drop _merge

gen underemp_deming = (inlist(deming_cat, "management", "other_professional"))

**********************************************
*** CALCULATE UNDEREMPLOYMENT BY AGE GROUP ***
**********************************************

unab AGEDUMS: agedum_*

foreach var of varlist `AGEDUMS' {

	preserve
		keep if `var' == 1
		
		collapse (sum) perwt, by(underemp_deming)
		gen age_cat = "`var'"
		
		reshape wide perwt, i(age_cat) j(underemp_deming)
		rename (perwt0 perwt1) (n_low n_high)
		gen underemp_deming = n_low / (n_low + n_high)
		
		tempfile DEMING_`var'
		save `DEMING_`var''
	restore
}

** COMBINE INDIVIDUAL DATASETS **
clear
tempfile countsdat
save `countsdat', emptyok
count
foreach x in `AGEDUMS' {
	append using `DEMING_`x''
	save `"`countsdat'"', replace
} 

replace age_cat = substr(age_cat, strpos(age_cat, "_")+1, .)
replace age_cat = subinstr(age_cat, "_", "-", .)
keep age_cat underemp_deming

save "../intermediate/deming_underemployment", replace
