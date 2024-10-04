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

** CLEAN EDUCATION REQUIREMENTS **
replace educ_req = "Some college/other" if strpos(educ_req, "Some college") | ///
 strpos(educ_req, "Postsecondary")

** ASSIGN ORDINAL RANKING TO EDUCATIONAL REQUIREMENTS **
gen educ_req_nbr = 1
	replace educ_req_nbr = 2 if strpos(educ_req, "High school")
	replace educ_req_nbr = 3 if educ_req == "Some college/other"
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

******************************
*** DEDUPLICATE CROSSWALK  ***
******************************

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

** CHECK BLS OCC REQUIREMENTS
merge m:1 occ_soc using `BLS_REQ'
	assert _merge == 3
	drop _merge

** KEEP HIGHEST-EMPLOYMENT DUPLICATE BLS OCC BY EDUC REQ ***
bysort occ_acs educ_req_nbr: egen educ_req_emp = sum(tot_emp)
gsort occ_acs educ_req_nbr -tot_emp
bysort occ_acs educ_req_nbr: gen n = _n
	keep if n == 1
	drop n

** ASSIGN EDUC REQ WITH CLOSEST WEIGHTED AVG EMPLOYMENT DUPLICATES **
bysort occ_acs: gen n = _n
bysort occ_acs: egen allocc_emp = sum(educ_req_emp)
	gen pct = educ_req_emp / allocc_emp
	gen wgt = pct * n
bysort occ_acs: egen wtd_avg = sum(wgt)
	gen diff = abs(n - wtd_avg)
	drop n
	
** EXPORT DUPLICATES TO EXCEL **
preserve
	drop if pct == 1
	unique occ_acs
	drop educ_req wgt wtd_avg diff dup_acs tot_emp
	order occ_acs acs_occ_t occ_soc bls_occ_title educ_req_n educ_req_e ///
	allocc_emp pct
	
	bysort occ_acs: egen maxpct = max(pct)	
		gsort maxpct occ_acs -pct
		drop maxpct
	
	export delimited "output/xwalk_acs_duplicates.csv", replace
restore

** REMOVE UNECCESARY BLS OCCUPATIONS **
gsort occ_acs diff
bysort occ_acs: gen n = _n
keep if n == 1

** REMOVE UNNECESSARY VARIABLES **
drop dup_acs *_emp pct wgt wtd_avg diff n 

** SAVE CLEANED CROSSWALK **
isid occ_acs
tempfile XWALK
save `XWALK'

****************************
*** CREATE FINAL DATASET ***
****************************

use "../intermediate/ipums_filtered", clear

** MERGE IN CROSSWALK **
merge m:1 occ_acs using `XWALK'
assert _merge == 3
drop _merge

** CREATE AGE CATEGORIES **
gen agedum_all = 1
gen agedum_22_23 = (age < 24)
gen agedum_22_27 = (age > 21 & age < 28)
gen agedum_28_33 = (age > 27 & age < 34)
gen agedum_34_39 = (age > 33 & age < 40)
gen agedum_40_45 = (age > 39 & age < 46)
gen agedum_25_54 = (age > 24 & age < 55) 
gen agedum_25_34 = (age > 24 & age < 35)
gen agedum_35_44 = (age > 34 & age < 45)
gen agedum_45_54 = (age > 44 & age < 55)
gen agedum_55_64 = (age > 54 & age < 65)

** CREATE CLEAN EDUCATION CATEGORIES **
assert !inlist(educd, 0,1,999)

gen cln_educ_cat = "less_hs"
	replace cln_ed = "hs" if inlist(educd, 62,63,64)
	replace cln_ed = "some_college" if inlist(educd, 65,70,71,80,90,100,110,111,112,113)
	replace cln_ed = "associates" if inlist(educd,81,82,83)
	replace cln_ed = "bachelors" if educd==101
	replace cln_ed = "masters" if educd==114
	replace cln_ed = "doctorate_prof_degree" if inlist(educd,115,116)
	
label define educ_cat_lbl 1 less_hs 2 hs 3 some_college 4 associates ///
 5  bachelors 6 masters 7 doctorate_prof_degree
 
encode cln_educ_cat, gen(cln_educ_cat_nbr) label(educ_cat_lbl)

** CREATE DUMMY FOR POSTSECONDARY DEGREES **
gen postsec_degree_dum = (cln_educ_cat_nbr > 4)

** CREATE EDUCATION GROUPS BY REQUIREMENT **
gen agg_educ_lvl = "undereduc" if cln_educ_cat_nbr < educ_req_nbr
	replace agg_educ_lvl = "bls_educ" if cln_educ_cat_nbr == educ_req_nbr
	replace agg_educ_lvl = "overeduc" if cln_educ_cat_nbr > educ_req_nbr

** EXPORT DATA **
label drop year_lbl
save "../intermediate/clean_acs_data", replace
