/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ANALYZE OCC XWALK
*** DATE:    05/20/2024
******************************/

clear
capture log close

*********************************************
*** CLEAN BLS EDUCATION REQUIREMENTS DATA ***
*********************************************

** IMPORT & CLEAN DATA **
import excel using "input/education.xlsx", sheet("Table 5.4") ///
 cellra(A2) first case(lower) clear

drop if mi(b)
keep b typicaleduc
rename (b t) (occ_soc educ_req)

** ASSIGN ORDINAL RANKING TO EDUCATIONAL REQUIREMENTS **
gen educ_req_nbr = 1
	replace educ_req_nbr = 2 if strpos(educ_req, "High school")
	replace educ_req_nbr = 3 if strpos(educ_req, "Some college")
	replace educ_req_nbr = 3.5 if strpos(educ_req, "Postsecondary")
	replace educ_req_nbr = 4 if strpos(educ_req, "Associate")
	replace educ_req_nbr = 5 if strpos(educ_req, "Bachelor")
	replace educ_req_nbr = 6 if strpos(educ_req, "Master")
	replace educ_req_nbr = 7 if strpos(educ_req, "Doctoral")

** SAVE DATA **
tempfile BLS_REQ
save `BLS_REQ'

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
	export delimited "output/xwalk_acs_duplicates.csv", replace
restore

** ASSIGN HIGHEST EMPLOYMENT SOC CODE TO DUPLICATES **
bysort occ_acs: egen max_emp = max(tot_emp)
drop if tot_emp != max_emp

** REMOVE UNNECESSARY VARIABLES **
drop dup_acs max_emp

** SAVE CLEANED CROSSWALK **
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
merge m:1 occ_soc using `BLS_REQ'
assert _merge!=1
keep if _merge ==3
drop _merge

** CREATE EDUCATION GROUPS BY REQUIREMENT **
gen agg_educ_lvl = "undereduc" if cln_educ_cat_nbr < educ_req_nbr
	replace agg_educ_lvl = "bls_educ" if cln_educ_cat_nbr == educ_req_nbr
	replace agg_educ_lvl = "overeduc" if cln_educ_cat_nbr > educ_req_nbr

** EXPORT DATA **
label drop year_lbl
save "../intermediate/clean_acs_data", replace
