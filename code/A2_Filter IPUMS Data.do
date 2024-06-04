/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: FILTER IPUMS DATA
*** DATE:    05/20/2024
******************************/

cd "$CD"

*******************
*** FILTER DATA ***
*******************

log using "output/ACS_filtering.txt", text replace
** KEEP NOT-IN-SCHOOL RECORDS **
label list school_lbl
tab school
keep if school == 1

** KEEP EMPLOYED **
label list empstat_lbl
tab empstat
keep if empstat == 1

** KEEP FULL-YR WORKERS **
label list wkswork2_lbl
tab wkswork2
keep if wkswork2 == 6

** KEEP FT WORKERS **
sum uhrs, d
keep if uhrs >=35

** DROP MILITARY **
tab occ2010 if inlist(occsoc, "551010", "552010", "553010", "559830")
drop if inlist(occsoc, "551010", "552010", "553010", "559830")

** DROP NO WAGE INCOME OBS **
count if incwage <= 0
drop if incwage <= 0
log close

**************************
*** PREPARE FINAL DATA ***
**************************

** CREATE CLEAN EDUCATION CATEGORIES **
assert !inlist(educd, 0,1,999)

gen cln_educ_cat = "less_hs"
	replace cln_ed = "hs" if inlist(educd, 62,63,64)
	replace cln_ed = "some_college" if inlist(educd, 70,71,80,90,100,110,111,112,113)
	replace cln_ed = "associates" if inlist(educd,81,82,83)
	replace cln_ed = "bachelors" if educd==101
	replace cln_ed = "masters" if educd==114
	replace cln_ed = "doctorate_prof_degree" if inlist(educd,115,116)
	
label define educ_cat_lbl 1 less_hs 2 hs 3 some_college 4 associates ///
 5  bachelors 6 masters 7 doctorate_prof_degree
 
encode cln_educ_cat, gen(cln_educ_cat_nbr) label(educ_cat_lbl)

** CREATE DUMMY FOR POSTSECONDARY DEGREES **
gen postsec_degree_dum = (cln_educ_cat_nbr > 4)

** RENAME OCCUPATION CODES **
rename (occ occsoc) (occ_acs occ_soc_ipums)

** CREATE AGE CATEGORIES **
gen agedum_all = 1
gen agedum_22_27 = (age>21 & age <28)
gen agedum_25_54 = (age>24 & age <54) 
gen agedum_25_34 = (age>24 & age <35)
gen agedum_35_44 = (age>34 & age<45)
gen agedum_45_54 = (age>44 & age<55)
gen agedum_55_64 = (age>54 & age<65)

** EXPORT DATA
save "../intermediate/ipums_filtered", replace
