/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: UNDEREMPLOYMENT
*** PURPOSE: CLEAN BLS EP DATA
*** DATE:    06/02/2024
******************************/

** IMPORT & CLEAN DATA **
import excel using "input/education.xlsx", sheet("Table 5.4") ///
 cellra(A2) first case(lower) clear

drop if mi(b)
keep b typicaleduc /* drop unnecessary variables */
rename (b t) (occ_soc educ_req)

** ASSIGN ORDINAL RANKING TO EDUCATIONAL REQUIREMENTS **
gen educ_req_nbr = 1
	replace educ_req_nbr = 2 if strpos(educ_req, "High school")
	replace educ_req_nbr = 3 if strpos(educ_req, "Some college")
	replace educ_req_nbr = 3.5 if strpos(educ_req, "Postsecondary")
	replace educ_req_nbr = 4 if strpos(educ_req, "Associate")
	replace educ_req_nbr = 5 if strpos(educ_req, "Bachelor")
	replace educ_req_nbr = 6 if strpos(educ_req, "Master")
	replace educ_req_nbr = 7 if strpos(educ_req, "Doctoral")

** SAVE DATASET **
save "../intermediate/bls_educ_requirements", replace
