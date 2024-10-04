/********************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: ALT UNDEREMP DEFS
*** DATE:    09/09/2024
********************************/

use "../intermediate/alt_underemployment_defs", clear
*********************************
*** CREATE MEDIAN WAGE GRAPHS ***
*********************************
preserve
drop if med_wage > 200000
** CREATE RM GRAPHS **
twoway (scatter med_wage ba_plus if college_occ_p == 0, msize(small)) ///
 (scatter med_wage ba_plus if college_occ_p == 1, msize(small)) ///
 (lfit med_wage ba_plus if college_occ_p == 0, lwidth(thick) lcolor(green)) ///
 (lfit med_wage ba_plus if college_occ_p == 1, lwidth(thick) lcolor(dkorange)), ///
 ytitle("Occ. med. earnings", size(small)) xtitle("BA+ share of workers", size(small)) ///
 ylabel(0 "0" 50000 "$50K" 100000 "$100K" 150000 "150K$" 200000 "$200K", labsize(vsmall)) ///
 xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", labsize(vsmall)) ///
 graphregion(margin(r=1)) title("RM (plurality)", size(medsmall)) ///
 yscale(titlegap(*6)) legend(off) name(topleft, replace)
 
twoway (scatter med_wage ba_plus if college_occ_m == 0, msize(small)) ///
 (scatter med_wage ba_plus if college_occ_m == 1, msize(small)) ///
 (lfit med_wage ba_plus if college_occ_maj == 0, lwidth(thick) lcolor(green)) ///
 (lfit med_wage ba_plus if college_occ_m == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(off) ysc(off) ytitle("") xtitle("BA+ share of workers", size(small)) ///
 xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", labsize(vsmall)) ///
 graphregion(margin(r=10)) title("RM (majority)", size(medsmall)) ///
 name(topright, replace)

** CREATE OER/EP GRAPHS **
twoway (scatter med_wage ba_plus if oer_ba_j == 0, msize(small)) ///
 (scatter med_wage ba_plus if oer_ba_j == 1, msize(small)) ///
 (lfit med_wage ba_plus if oer_ba_j == 0, lwidth(thick) lcolor(green)) ///
 (lfit med_wage ba_plus if oer_ba_j == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(order(1 "<BA occs" 2 "BA+ occs") size(small)) ///
 xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", labsize(vsmall)) ///
 ytitle("Occ. med. earnings", size(small)) xtitle("BA+ share of workers", size(small)) ///
 ylabel(0 "0" 50000 "$50K" 100000 "$100K" 150000 "150K$" 200000 "$200K", labsize(vsmall)) ///
 graphregion(margin(r=1)) title("OER", size(medsmall)) yscale(titlegap(*6)) ///
 name(midleft, replace)
 
twoway (scatter med_wage ba_plus if ep_ba_j == 0, msize(small)) ///
 (scatter med_wage ba_plus if ep_ba_j == 1, msize(small)) ///
 (lfit med_wage ba_plus if ep_ba_j == 0, lwidth(thick) lcolor(green)) ///
 (lfit med_wage ba_plus if ep_ba_j == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(order(1 "<BA occs" 2 "BA+ occs") size(small)) ///
 xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%", labsize(vsmall)) ///
 ysc(off) ytitle("") xtitle("BA+ share of workers", size(small)) ///
 graphregion(margin(r=10)) title("EP", size(medsmall)) name(midright, replace)

** ADD DEMING GRAPH **
twoway (scatter med_wage ba_plus if deming_ba == 0, msize(small)) ///
 (scatter med_wage ba_plus if deming_ba == 1, msize(small)) ///
 (lfit med_wage ba_plus if deming_ba == 0, lwidth(thick) lcolor(green)) ///
 (lfit med_wage ba_plus if deming_ba == 1, lwidth(thick) lcolor(dkorange)), ///
 legend(order(1 "<BA occs" 2 "BA+ occs") size(small)) ///
 xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%") ///
 ytitle("Occ. med. earnings") xtitle("BA+ share of workers") ///
ylabel(0 "0" 50000 "$50K" 100000 "$100K" 150000 "150K$" 200000 "$200K") ///
 graphregion(margin(r=10)) title("Deming") yscale(titlegap(*6))

graph export "output/deming_shares_and_earnings.png", width(3000) height(2500) replace
 
graph combine topleft topright midleft midright, rows(2) cols(2)

graph export "output/baplus_shares_and_earnings_by_defs.png", width(4250) height(3500) replace
restore
******************************
*** CREATE KDENSITY GRAPHS ***
******************************
keep bls occ* oer ep college_occ* deming_ba*
tempfile DEFS
save `DEFS'

use "../intermediate/clean_acs_data", clear
	keep if cln_educ_cat == "bachelors" & ftfy == 1 & agedum_25_54 == 1
	
merge m:1 bls_occ occ_soc occ_acs using `DEFS'

** REALIZED MATCHES **
twoway (kdens incwage if college_occ_p == 0 & incwage < 200000 [pw = perwt], ll(0)) ///
 (kdens incwage if college_occ_p == 1 & incwage < 200000 [pw = perwt], ll(0)), ///
 legend(off) ytitle("Density", size(small)) yscale(titlegap(*6)) ///
 ylab(0 "0" 0.000005 "0.0005%" 0.00001 "0.0010%" 0.000015 "0.0015%" 0.00002 "0.0020%", labsize(vsmall)) ///
 xlab(0 "0" 50000 "$50K" 100000 "$100K" 150000 "$150K" 200000 "$200K", labsize(vsmall)) ///
 xtitle("") graphregion(margin(r=1)) title("RM (plurality)", size(medsmall)) ///
 name(topleft, replace)

twoway (kdens incwage if college_occ_m == 0 & incwage < 200000 [pw = perwt], ll(0)) ///
 (kdens incwage if college_occ_m == 1 & incwage < 200000 [pw = perwt], ll(0)), ///
 legend(off) ytitle("") ysc(off) xtitle("") graphregion(margin(r=10)) ///
 xlab(0 "0" 50000 "$50K" 100000 "$100K" 150000 "$150K" 200000 "$200K", labsize(vsmall)) ///
 title("RM (majority)", size(medsmall)) name(topright, replace)
 
** OER VS EP **
twoway (kdens incwage if oer == 0 & incwage < 200000 [pw = perwt], ll(0)) ///
 (kdens incwage if oer == 1 & incwage < 200000 [pw = perwt], ll(0)), ///
 legend(order(1 "<BA occs" 2 "BA+ occs")) ytitle("Density", size(small)) ///
 ylab(0 "0" 0.000005 "0.0005%" 0.00001 "0.0010%" 0.000015 "0.0015%" 0.00002 "0.0020%", labsize(vsmall)) ///
 xlab(0 "0" 50000 "$50K" 100000 "$100K" 150000 "$150K" 200000 "$200K", labsize(vsmall)) ///
 xtitle("") graphregion(margin(r=1)) title("OER", size(medsmall)) ///
 yscale(titlegap(*6)) name(bleft, replace)

twoway (kdens incwage if ep_ba == 0 & incwage < 200000 [pw = perwt], ll(0)) ///
 (kdens incwage if ep_ba == 1 & incwage < 200000 [pw = perwt], ll(0)), ///
 legend(order(1 "<BA occs" 2 "BA+ occs")) ytitle("") graphregion(margin(r=10)) ///
 xlab(0 "0" 50000 "$50K" 100000 "$100K" 150000 "$150K" 200000 "$200K", labsize(vsmall)) ///
 title("EP", size(medsmall)) ysc(off) xtitle("") name(bright, replace)

twoway (kdens incwage if deming_ba_j == 0 & incwage < 200000 [pw = perwt], ll(0)) ///
 (kdens incwage if deming_ba_j == 1 & incwage < 200000 [pw = perwt], ll(0)), ///
 legend(order(1 "<BA occs" 2 "BA+ occs")) ytitle("Density") ///
 ylab(0 "0" 0.000005 "0.0005%" 0.00001 "0.0010%" 0.000015 "0.0015%" 0.00002 "0.0020%") ///
 xlab(0 "0" 50000 "$50K" 100000 "$100K" 150000 "$150K" 200000 "$200K") ///
 xtitle("") graphregion(margin(r=1)) title("Deming") ///
 yscale(titlegap(*6))
 
graph export "output/deming_earnings_kdens.png", width(3000) height(2500) replace
 
graph combine topleft topright bleft bright, rows(2) cols(2)

graph export "output/baplus_earnings_kdens_by_defs.png", width(4250) height(3500) replace
