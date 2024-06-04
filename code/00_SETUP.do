/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: SETUP 
*** DATE:    06/02/2024
******************************/

clear
capture log close
set more off, perm
set rmsg on
*ssc install unique

** SET KEY CUTOFFS **
global NFLAG 75 // minimum number of observations to consider median wages
global OVEREDUC_PREMIUM 0.2 // cutoff for acceptable premium of overeducation
global BA_PREMIUM 0.15 // cutoff for BA wage premium over HS wage

** SET WORKING DIRECTORY GLOBAL **
global CD "C:\Users\mattm\OneDrive\Desktop\Underemployment\college-underemployment"
cd "$CD"

** SET IPUMS DATA DOWNLOAD NAME **
global IPUMS "usa_00004.dat"

** CREATE DATASET FOR ANALYSIS **
do "code/A1_IPUMS_download.do"
cd "$CD"
do "code/A2_Filter IPUMS Data.do"
do "code/A3_Clean BLS Data.do"
do "code/A4_Create Underemployment Dataset.do"
