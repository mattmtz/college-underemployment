/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: SANITY CHECK
*** DATE:    07/01/2024
********************************/

************************************
*** CHECK UNDEREMPLOYMENT SHARES ***
************************************

use "../intermediate/clean_acs_data", clear

** KEEP AGE CATEGORY OF INTEREST **
keep if agedum_25_54 == 1 & ft == 1
drop agedum*

** CALCULATE COMPARISON WAGES BY OCC **
preserve
	keep if agg_educ_lvl == "bls_educ"
	gen n = 1
	collapse (sum) n (p50) comp_wage = incwage [pw = perwt], ///
	 by(bls_occ educ_re* occ_soc)

	tempfile MEDWAGE
	save `MEDWAGE'
restore

merge m:1 bls_occ educ_re* occ_soc using `MEDWAGE'
	assert _merge == 3
	assert n >= $NFLAG
	drop n _merge

** CALCULATE BA OVEREDUC BY DEFINITION **
keep if cln_educ_cat == "bachelors"

gen underemp_bls = 0
	replace underemp_bls = perwt if educ_req_nbr < 5

gen underemp = 0
	replace underemp = perwt if educ_req_nbr == 1
	replace underemp = perwt if educ_req_nbr == 2 & ///
	 incwage <= $BA_PREM1 * comp_wage
	replace underemp = perwt if inlist(educ_req_nbr, 3, 3.5, 4) & ///
	 incwage <= $BA_PREM2 * comp_wage
	replace underemp = 0 if mi(comp_wage)

	
** COLLAPSE DATA **
gen n_raw = 1
gen n_cln = perwt
collapse (sum) n_raw n_cln perwt underem*, by(bls_occ educ_re*)
	replace underemp = 0 if n_raw < $NFLAG
	replace n_cln = 0 if n_raw < $NFLAG

** CALCULATE SHARES **
collapse (sum) n_cln perwt underem*

gen bls = underemp_bls / perwt
gen gucew = underemp / n_cln

gen Measure = "underemployment"
table Measure, c(sum bls  sum gucew) format("%8.4f")
