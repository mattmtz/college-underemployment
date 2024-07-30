/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: FILTER IPUMS DATA
*** DATE:    07/12/2024
******************************/

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

** DROP MILITARY **
tab occ2010 if inlist(occsoc, "551010", "552010", "553010", "559830")
drop if inlist(occsoc, "551010", "552010", "553010", "559830")

** DROP NO WAGE INCOME OBS **
count if incwage <= 0
drop if incwage <= 0

** KEEP AGES 22-54 **
keep if age >= $MINAGE & age <= $MAXAGE

** IDENTIFY FULL-YR WORKERS **
label list wkswork2_lbl
tab wkswork2
count if wkswork2 == 6

** IDENTIFY FT WORKERS **
gen ftfy_flag = (uhrs >=30 & wkswork2 == 6)
	label define ftfy_flag_lbl 0 "Not FTFY" 1 "FTFY (30+ hrs/wk)"
	label values ftfy_flag ftfy_flag_lbl

tab ftfy_flag

tab educd

log close

*****************
*** SAVE DATA ***
*****************

** RENAME OCCUPATION CODES **
rename (occ occsoc) (occ_acs occ_soc_ipums)

** EXPORT DATA
save "../intermediate/ipums_filtered", replace
