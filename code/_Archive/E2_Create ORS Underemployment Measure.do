/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: OCS UNDEREMPLOYMENT
*** DATE:    07/01/2024
********************************/

**********************
*** CLEAN RAW DATA ***
**********************

** LOAD DATA **
import excel using "input/ors-complete-dataset.xlsx", sheet("ORS 2023 dataset") ///
 first case(l) clear
 
** FILTER DATA **
keep if category == "Minimum education level" & additive != "Literacy required"

** DROP NON-DETAILED OCCUPATIONS **
gen drop_flag = (substr(reverse(soc2018),1,1) == "0")
	replace drop_flag = 0 if inlist(soc2018, "131020", "132020", "292010", ///
	 "311120", "397010", "474090", "512090")
	 
tab soc2018 if drop_flag == 1
drop if drop_flag == 1
drop drop_flag

** CLEAN EDUCATION CATEGORIES **
gen cln_text = subinstr(estimatetext, "Percent of workers, ", "", .)
	replace cln_text = subinstr(cln_text, "minimum education level is a ", "", .)
	replace cln_text = subinstr(cln_text, "minimum education level is an ", "", .)
	replace cln_text = subinstr(cln_text, "vocational degree", "voc_deg", .)
	replace cln_text = "no min" if strpos(cln_text, "no minimum")
	
encode cln_text, gen(educ_req)

** DESTRING ESTIMATES **
destring estimate, gen(dstr_est) ignore("<" ">")

** CALCULATE TOTAL PERCENTAGES **
bysort soc2018: egen tot_pct = sum(dstr_est)
	
**********************************
*** SURVEY IMPRECISION IN DATA ***
**********************************

** OVERVIEW OF NAIVE TOTAL SHARES **
preserve
	collapse (mean) tot_pct, by(soc2018)
	
	hist tot_pct, freq xtitle("Sum of estimates") lcolor(white) fcolor(navy) ///
	 title("Naive totals of education requirement estimates", color(black)) ///
	 subtitle("by occupation", color(black))
	 
restore

** EXPORT LIST OF <100% FILES **
preserve
	keep if tot_pct < 100
	keep soc2018 occupation educ_req dstr_est tot_pct
	
	label list educ_req
	reshape wide dstr_est, i(soc occ tot) j(educ)
	rename(dstr_est1 dstr_est2 dstr_est3 dstr_est4 dstr_est5 dstr_est6 ///
	 dstr_est7 dstr_est8 dstr_est9) (aa aa_voc ba phd hs hs_voc ma less_hs prof_deg)
	 
	isid soc
	foreach var of varlist aa-prof_deg {
		replace `var' = 0 if mi(`var')
	}
	
	order soc occ tot less h* aa aa_v ba ma prof phd
	gsort tot_pct
	
	export excel using "output/ors_low_estimates.xlsx", firstrow(var) replace
restore

** IMPRECISE ESTIMATES OVERVIEW **
preserve
	keep if strpos(estimate, "<") | strpos(estimate, ">")
	gen n = 1
	collapse (sum) n, by(soc2018 estimate)
	
	encode estimate, gen(estnum)
	drop estimate
	label list estnum
	reshape wide n, i(soc2018) j(estnum)
	rename (n1 n2 n3 n4 n5 n6 n7 n8 n9 n10) (lo lt10 lt15 lt20 lt25 lt30 lt40 ///
	 lt45 lt5 hi)
	 
	** SCOPE OF OCCUPATIONS WITH "<0.5" ESTIMATES **

	count if mi(lo) // every single SOC has at least one "<0.5"
	
	graph bar (count), over(lo) blabel(bar) ytitle("Number of occupations") ///
	 title("Occ. counts by number of '<0.5' estimate occurences") ///
	 ysc(titlegap(*9))
	graph close
	
	** COUNT OF SOC CODES THAT HAVE MORE THAN "<0.5" **
	foreach var of varlist lt10-hi {
		replace `var' = 0 if mi(`var')
	}

	egen other_imprecise = rowtotal(lt10-hi)
	tab other_imprecise
restore

*****************************
*** CONSERVATIVE APPROACH ***
*****************************

preserve
	keep soc occup educ_req estimate

	** RESHAPE WIDE DATA **
	label list educ_req
	reshape wide estimate, i(soc occup) j(educ_req)
	rename (estimate1 estimate2 estimate3 estimate4 estimate5 estimate6 estimate7 ///
	 estimate8 estimate9) (aa aa_voc ba phd hs hs_voc mast no_min prof)
 
	foreach var of varlist aa-prof {
		replace `var' = "0" if `var' == ""
	}

	order soc occ no_min h* a* ba mast phd prof

	gen college_occ_strict = 0

	** CASE I: 99.5% **
	foreach var of varlist ba-prof {
		replace college_occ =  1 if `var' == ">99.5"
	}

	** CASE II: CLEAR BA+ JOBS **
	foreach var of varlist ba-prof {
		gen dstr_`var' = `var'
		replace dstr_`var' = "0" if strpos(`var', "<") | strpos(`var', ">")
		destring dstr_`var', replace
	}
	
	gen strict_ba_plus = dstr_ba + dstr_mas + dstr_ph + dstr_pr
	replace college_occ_strict = 1 if strict_ba_plus > 50

	*bro if tot_ba_plus > 30 & tot_ba_plus < 50
	
	keep soc occup strict_ba_plus college_occ
	tempfile STRICT
	save `STRICT'
restore

***********************
*** NAIVE ESTIMATES ***
***********************

** CREATE SHARES **
gen est_naive = dstr_est / tot_pct
	
** DESTRING DATA **
	
** RESHAPE WIDE DATA **
keep soc occ tot_pct educ_req est_naive

	label list educ_req
	reshape wide est_naive, i(soc occup tot) j(educ_req)
	rename (est_naive1 est_naive2 est_naive3 est_naive4 est_naive5 est_naive6 ///
	 est_naive7 est_naive8 est_naive9) (aa aa_voc ba phd hs hs_voc mast no_min prof)
	 
foreach var of varlist aa-prof {
	replace `var' = 0 if mi(`var')
}

gen college_occ_lax = 0

gen lax_ba_share = ba + mast + phd + prof
	replace college_occ_lax = 1 if lax_ba_share > .5

keep soc occ tot_pct lax_ba_share college_occ_lax


****************************
*** CREATE FINAL DATASET ***
****************************

** MERGE DATA **
merge 1:1 soc occup using `STRICT', nogen
	order soc occ tot strict lax college_occ_s
	
tab coll*

** EXPORT DEFINITIONAL DISAGREEMENTS **
preserve
	keep if college_occ_lax == 1 & college_occ_strict == 0
	export excel using "output/ors_definition_disagreements.xlsx", firstrow(var) replace
restore

drop occ
gen occ_soc = substr(soc, 1,2) + "-" + substr(soc, 3,8)
drop soc2018

***************************
*** MERGE WITH ACS DATA ***
***************************

merge 1:m occ_soc using "../intermediate/clean_acs_data"
	keep if agedum_25_54 == 1 & cln_educ_cat == "bachelors"
	
** CHECK MERGE **
tabstat perwt, by(_merge) stat(sum) format(%14.0fc)

** CHECK UNDEREMPLOYMENT **
tabstat perwt, by(college_occ_strict) stat(sum) format(%14.0fc) miss
tabstat perwt, by(college_occ_lax) stat(sum) format(%14.0fc) miss
