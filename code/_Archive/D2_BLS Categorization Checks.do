/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: SANITY CHECK
*** DATE:    07/01/2024
********************************/

use "../intermediate/clean_acs_data", clear
	keep if cln_educ_cat == "bachelors"

gen underemp_status = "underemployed" if educ_req_nbr < 5
	replace underemp = "not underemployed" if mi(underemp)
	
*******************
*** SET UP LOOP ***
*******************

forvalues timevar = 1/2 {
	gen incl_pt = "All workers"
		replace incl_pt = "FT workers only" if `timevar' == 1

	*** 22-27 ***
	preserve
		drop if `timevar' == 1 & ft == 0
		keep if agedum_22_27 == 1
	
		collapse (sum) perwt, by(underemp incl_pt)
		egen tot = sum(perwt)
		gen share = perwt / tot
		gen group = "22-27"
	
		tempfile RGS_`timevar'
		save `RGS_`timevar''
	restore

	*** 22-23 ***
	preserve
		drop if `timevar' == 1 & ft == 0
		keep if age<24

		collapse (sum) perwt, by(underemp incl_pt)
		egen tot = sum(perwt)
		gen share = perwt / tot
		gen group = "22-23"

		tempfile YOUNG_`timevar'
		save `YOUNG_`timevar''
	restore

	*** 5-YR AGE BANDS ***
	preserve
		drop if `timevar' == 1 & ft == 0
		/*keep if age > 24
		gen group = "25-34" if age <35
			replace group = "35-44" if age > 34 & age < 45
			replace group = "45-54" if age > 44 & age < 55
			replace group = "55-64" if age > 54 & age < 65
	    */
		
		keep if age > 23
		gen group = "25-29" if age < 30
			replace group = "30-34" if age > 29 & age < 35
			replace group = "35-39" if age > 34 & age < 40
			replace group = "40-44" if age > 39 & age < 45
			replace group = "45-49" if age > 44 & age < 50
			replace group = "50-54" if age > 49 & age < 55
			replace group = "55-59" if age > 54 & age < 60
			replace group = "60-64" if age > 59
		
		collapse (sum) perwt, by(underemp group incl_pt)
		bysort group: egen tot = sum(perwt)
		gen share = perwt / tot
		
		tempfile BANDS_`timevar'
		save `BANDS_`timevar''
	restore
	
		*** 25-54 ***
	preserve
		drop if `timevar' == 1 & ft == 0
		keep if age > 24 & age < 55
	
		collapse (sum) perwt, by(underemp incl_pt)
		egen tot = sum(perwt)
		gen share = perwt / tot
		gen group = "25-54"
		
		tempfile ALL_`timevar'
		save `ALL_`timevar''
	restore
	
	drop incl_pt
}

********************
*** CREATE TABLE ***
********************

clear
tempfile tabledat
save `tabledat', emptyok
count
forvalues i = 1/2 {
	append using `RGS_`i''
	append using `YOUNG_`i''
	append using `BANDS_`i''
	append using `ALL_`i''
	save `"`tabledat'"', replace
} 

label var group "Age group"
label var incl_pt "Workers considered"
table group incl_pt if underemp == "underemployed", c(sum share) format("%8.3f")

********************
*** CREATE GRAPH ***
********************
preserve
encode incl_pt, gen(status) // 1 = All workers, 2 = FT only
keep if underemp == "underemployed" & !inlist(group, "22-27", "25-54")
drop perwt tot incl_pt underemp
replace share = 100*share
reshape wide share, i(group) j(status)
	rename (share1 share2) (all ft_only)
	
graph bar all ft, over(group) legend(order(1 "All workers" 2 "FT workers only")) ///
 blabel(bar, color(white) pos(inside) format("%8.1f") size(vsmall)) ///
 ylabel(0 "0%" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%") ///
 ytitle("Unemployed share") b1title("Age group") ///
 title("BA worker underemployment by age group", color(black)) ///
 subtitle("(Underemployment defined by BLS education requirements)")
 
graph export "output/BLS_underemployment_by_age.png", replace
restore
