/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ALT UNDEREMP DEFS
*** DATE:    07/01/2024
********************************/

use "../intermediate/clean_acs_data", clear
	keep if ft == 1 & agedum_25_54 == 1
	gen educ_group = cln_educ_cat
		replace educ_group = "other_lo" if inlist(cln_educ_cat_nbr, 1, 2, 3, 4)
		replace educ_group = "other_hi" if inlist(cln_educ_cat_nbr, 6, 7)
		
tempfile ALLDAT
save `ALLDAT'
	
******************************
*** IDENTIFY RM CATEGORIES ***
******************************

gen n_workers = 1
		
** COLLAPSE DATA TO KEY CATEGORIES **
collapse (sum) n_workers (median) incwage [pw = perwt], ///
 by(occ_acs occ_soc bls_occ_title educ_group postsec)
		 
* Get <BA/BA wages by occupation
gen lo_wage_int = 0
	replace lo_wage_int = incwage if educ_group == "other_lo"
	bysort occ_acs occ_soc bls: egen lo_wage = max(lo_wage_int)
			
gen ba_wage_int = 0
	replace ba_wage_int = incwage if educ_group == "bachelors"
	bysort occ_acs occ_soc bls: egen ba_wage = max(ba_wage_int)
			
drop *_wage_int incwage
		
* COLLAPSE BY POSTSECONDARY DEGREE STATUS **
gen ba_workers = n_workers if educ_group == "bachelors"
	replace ba_workers = 0 if mi(ba_workers)
			
gen lo_workers = n_workers if educ_group == "other_lo"
	replace lo_workers = 0 if mi(lo_workers)
			
collapse (sum) *_workers, by(occ_acs occ_soc bls_occ postsec *_wage)
		
bysort occ_acs occ_soc: egen tot_bas = max(ba_workers)
	drop ba_workers
			
bysort occ_acs occ_soc: egen tot_lo = max(lo_workers)
	drop lo_workers
		
reshape wide n_workers, i(occ* bls tot_* *_wage) j(postsec)
	rename (n_workers0 n_workers1) (less_ba ba_plus)
	replace less_ba = 0 if mi(less_ba)
	replace ba_plus = 0 if mi(ba_plus)
		
gen ba_plus_share = ba_plus / (ba_plus + less_ba)		
gen majority_ba_plus = (ba_plus > less_ba)
		
merge 1:m occ_acs occ_soc bls_occ using `ALLDAT'
	assert _merge == 3
	drop _merge
		
keep if cln_educ_cat == "bachelors"
keep occ_acs occ_soc bls_occ lo_wage less_ba ba_plus_share majority_ba ///
 cln_educ_cat incwage perwt

******************************************
*** ANALYZE DIFFERENCES BY RM CATEGORY ***
******************************************

label define majority_ba_lbl 0 "<BA+ occupations" 1 "BA+ occupations"
label values majority majority_ba_lbl

** BA WAGES **
twoway (kdensity incwage if maj == 0 & incwage < 210000) ///
 (kdensity incwage if maj == 1 & incwage < 210000), ///
 ylabel(0 "0" 0.000005 "0.5e-5" 0.00001 "1.0e-5" 0.000015 "1.5e-5")  ///
 legend(order(1 "<BA+ occupations" 2 "BA+ occupations")) ///
 xtitle("BA earnings (thousands of USD)") ytitle("Kernel Density") ///
 xlabel(0 "0" 50000 "50" 100000 "100" 150000 "150" 200000 "200") ///
 title("BA earnings by RM categorization") note("Earnings truncated above $210k/yr.")
 
graph box incwage, over(maj) noout title("BA earnings by RM categorization") ///
 ylabel(0 "0" 50000 "50" 100000 "100" 150000 "150" 200000 "200") ///
 ytitle("BA earnings (thousands of USD)")
 
tabstat incwage, by(majority) stat(p25 p50 mean p75) nototal format(%10.0fc)

** BA PREMIUM **
gen ba_prem = incwage / lo_wage - 1
	format ba_prem %4.2f
gen ba_prem_lo = incwage / lo_wage - 1 if maj == 0
gen ba_prem_hi = incwage / lo_wage - 1 if maj == 1

graph box ba_prem, over(maj) noout ytitle("BA premium") ///
 ylabel(-1(0.5)3, format(%3.1f)) title("BA premium over <BA workers by RM categorization")
 
tabstat ba_prem, by(majority) stat(p25 p50 mean p75) nototal format

preserve
gen n = 1
collapse (sum) n (median) ba_prem ba_plus_share [pw = perwt], by(occ_acs occ_soc maj)

twoway (scatter ba_prem ba_plus, msize(small)) ///
 (lfit ba_prem ba_plus if maj == 0, lwidth(thick)) ///
 (lfit ba_prem ba_plus if maj == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(order(2 "Fitted line (<BA occs)" 3 "Fitted line (BA+ occs)")) ///
 ytitle("Occupational median premium") xtitle("BA+ share of workers") ///
 ylabel(0 "0%" .5 "50%" 1 "100%" 1.5 "150%" 2 "200%") ///
 title("Median BA premium by BA+ share of workers")
