/**************************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CREATE MEMO FIGURES
*** DATE:    07/17/2024
**************************************/

*** FIND EXAMPLE OCCUPATIONS ***
use "../intermediate/clean_acs_data", clear
	keep if inlist(cln_educ_cat, "hs", "bachelors") & educ_req_nbr == 2 &  ///
	 agedum_25_54 == 1
	 
collapse (sum) perwt, by(bls cln_educ_cat)
	
bysort bls: egen all_workers = sum(perwt)
	gen share_ = perwt / all_workers
	drop perwt
	
reshape wide share_, i(bls all_workers) j(cln_educ_cat) string

gen ba_hs_diff = share_ba - share_hs
gsort -ba_hs_diff

gen diffdum = (ba_hs_diff > 0)
tab diffdum

/* THE OCCUPATIONS WITH MORE BAs THAN HS GRADS EMPLOY ~30% OF ALL WORKERS IN
   THE SET OF OCCUPATIONS CONSIDERED TO BE HIGH SCHOOL LEVEL BY BLS
*/
preserve
	label var diffdum "Occs w/ more BAs than HSs"
	collapse (sum) all_workers, by(diffdum)
	egen tot = sum(all_workers)
	gen pct = all_workers / tot
	table diffdum, c(sum pct)
restore

gen rank = _n
*keep if rank < 6

gen age_cat = "25-54"
keep age_cat bls_occ ba_hs_diff rank
tempfile EXS
save `EXS'

*** MERGE TO FULL ACS DATA ***
use "../intermediate/clean_acs_data", clear
	keep if agedum_25_54 == 1
	gen age_cat = "25-54"

merge m:1 age_cat bls_occ using `EXS', keep(3) nogen

*** COLLAPSE DATA ***
gen educ_group = cln_educ_cat
	replace educ_group = "hs_or_less" if inlist(cln_educ_cat, "hs", "less_hs")
	replace educ_group = "ma_plus" if cln_educ_cat == "masters" | ///
	 strpos(cln_educ_cat, "doct")
	replace educ_group = "aa_other" if inlist(cln_educ_cat, "some_college", ///
	 "associates")
	 
gen n_educ_group = 1
	replace n_educ_group = 2 if inlist(cln_educ_cat, "some_college", "associates")
	replace n_educ_group = 3 if cln_educ_cat == "bachelors"
	replace n_educ_group = 4 if cln_educ_cat == "masters" | strpos(cln_educ_cat, "doct")
	
collapse (sum) perwt, by(bls rank occ_soc educ_req educ_group n_educ_group)

bysort bls: egen tot = sum(perwt)
	gen pct = perwt / tot
	
*** EXPORT DATA ***
order rank bls occ educ_req educ_group tot perwt pct
gsort rank n_educ_group
drop n_educ_group
export excel using "output/full_BA_shares_in_HS_occs.xlsx", first(var) replace

keep if rank <6
export excel using "$FILE", first(var) sheet("fig4_raw", replace)
