/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: FILTER IPUMS DATA
*** DATE:    07/12/2024
******************************/

**********************
*** CREATE DATASET ***
**********************

*** LOAD DATA FOR BAS & COMPARISON GROUP ***
use "../intermediate/underemployment_data", clear
keep if inlist(cln_educ_cat, "bls_educ", "bachelors") & !mi(educ_req) & ///
 educ_req_nbr < 6 & ftfy == 1

*** COLLAPSE DATA ***
collapse (sum) n_raw, by(age_cat educ_re* cln_educ_cat suff)

*** CALCULATE % OF OBS IN OCCS WITH SUFFICIENT DATA ***
reshape wide n_raw, i(age_cat cln_educ_cat educ_re*) j(suff)
	replace n_raw1 = 0 if mi(n_raw1)
	replace n_raw0 = 0 if mi(n_raw0)

gen tot = n_raw1 + n_raw0
gen pct = n_raw1 / tot
drop n_r*

reshape wide pct tot, i(age_cat educ_re*) j(cln_educ_cat) string
	gsort age_cat educ_req_nbr
	drop educ_req_nbr

*** EXPORT DATA ***
rename (totba pctba totbls pctbls) (tot_bas ba_suff_pct tot_comp_group ///
 comp_suff_pct)
 
export excel using "$FILE", first(var) sheet("sampling", replace)

****************************************
*** EXPLORE LOW AA-LEVEL SUFFICIENCY ***
****************************************

use "../intermediate/underemployment_data", clear
	keep if educ_req_nbr == 4 & age_cat == "22-23" & ftfy == 1 & ///
	cln_educ_cat == "all_workers"
	
hist n_raw if n_raw < 200, freq width(5) xline(75) xtitle("# of workers") ///
ytitle("# of AA-level occupations") title("AA-level occupation worker counts") ///
xlabel(0(10)150) note("28 total AA-level occupations. 5 have 200+ workers.")
	