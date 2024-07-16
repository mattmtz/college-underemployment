/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: SETUP 
*** DATE:    06/02/2024
******************************/

clear
capture log close
macro drop _all
set more off, perm
set rmsg on
*ssc install unique

** SET KEY CUTOFFS **
global MINAGE 22
global MAXAGE 64
global NFLAG 75 // minimum number of observations to consider median wages
global EDUC_PREM 0.1 // expected wage premium for additional yr of schooling
global BA_PREM1 (1 + 4*$EDUC_PREM ) // cutoff for BA wage premium over HS wage
global BA_PREM2 (1 + 2*$EDUC_PREM ) // cutoff for BA wage premium over AA wage

** SET WORKING DIRECTORY GLOBAL **
global CD "C:\Users\mattm\Desktop\Underemployment\college-underemployment"
cd "$CD"

** SET IPUMS DATA DOWNLOAD NAME **
global IPUMS "usa_00004.dat"

** CREATE DATASET FOR ANALYSIS **
do "code/A1_IPUMS Download.do"
cd "$CD"
do "code/A2_Filter IPUMS Data.do"
do "code/A3_Clean IPUMS Dataset.do"

** CREATE INTERMEDIATE DATASETS **
do "code/B1_Occupation Counts by Category.do"
do "code/B2_Create Categorized Dataset.do"
do "code/B3_Calculate Underemployment.do"

** TYPICAL RUNTIME: ~28 minutes
