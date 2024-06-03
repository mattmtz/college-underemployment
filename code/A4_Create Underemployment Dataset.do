/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ANALYZE OCC XWALK
*** DATE:    05/20/2024
******************************/

clear
capture log close

******************************
*** EMPLOYMENT BY SOC CODE ***
******************************

** LOAD DATA **
import excel using "input/national_M2023_dl.xlsx", ///
 sheet("national_M2023_dl") first case(lower) clear

keep occ_cod tot_emp
rename occ_cod occ_soc
duplicates drop

** SAVE DATA **
tempfile EMPL
save `EMPL'

*****************************
*** DEDUPLICATE CROSSWALK ***
*****************************

** LOAD DATA **
import excel using "input/nem-occcode-acs-crosswalk.xlsx", ///
 sheet("NEM SOC ACS crosswalk") cellra(A5) first case(lower) clear
 
drop sortorder
rename (matrixoccupationcode matrixoccupationtitle acscode acsocc) ///
 (occ_soc bls_occ_title occ_acs acs_occ_title)
 
** ADD EMPLOYMENT LEVELS **
merge m:1 occ_soc using `EMPL'
drop if _merge == 2
drop _merge

** IDENTIFY ACS DUPLICATES **
bysort occ_acs: gen dup_acs_dum = cond(_N==1,0,1)
unique occ_acs if dup_acs == 1

preserve
	keep if dup_acs > 0
	gsort occ_soc
	*export delimited "output/xwalk_acs_duplicates.csv", replace
restore

** ASSIGN HIGHEST EMPLOYMENT SOC CODE TO DUPLICATES **
bysort occ_acs: egen max_emp = max(tot_emp)
drop if tot_emp != max_emp

** REMOVE UNNECESSARY VARIABLES **
drop dup_acs max_emp

** SAVE CLEANED CROSSWALK **
*save "../intermediate/cleaned_bls_acs_xwalk", replace
tempfile XWALK
save `XWALK'

use "../intermediate/ipums_filtered", clear

****************************
*** CREATE FINAL DATASET ***
****************************

** MERGE IN CROSSWALK **
merge m:1 occ_acs using `XWALK'
assert _merge == 3
drop _merge

** MERGE IN BLS EP TABLE 5.4 **
merge m:1 occ_soc using "../intermediate/bls_educ_requirements"
assert _merge!=1
keep if _merge ==3
drop _merge

** EXPORT DATA **
save "../intermediate/underemployment_data", replace
