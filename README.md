# Overview
This repository hosts analysis done on the most recent ACS 5-yr sample data exploring the education levels and wages of workers in BLS-defined occupations. Incorporated into this analysis is the BLS definition of the "typical" education level required for entry into these occupations, using BLS Employment Projections ("EP") data. 

# Background 
The motivation for this analysis is a Strada Education Foundation ("Strada") report from February 2024 (the "Strada Report") about the prevalence of **underemployment** in the college-educated population. The Strada Report specifically claism that **52 percent** of graduates are underemployed a year after graduation" and "a decade after graduation, **45 percent** of graduates are underemployed" (Strada Report, p. 6). The Strada Report notes that these rates "vary greatly by college major" (Strada Report, p. 6).

>[!NOTE]
>Important notes from the Strada Report's underemployment classification:
>- Employees were classified as underemployed if "less than half of workers either had, or were required to have, a bachelor's degree" (Strada Report, pp. 50-51).
>- The Strada Report's methodology "yielded the same occupational classification as the method used by the BLS" Employment Projections (EP) to classify the "typical education needed for entry" into an occupation (Strada Report, p. 50).[^1]
>[^1]: The Strada Report combines (1) EP Table 5.3 "Educational attainment for workers 25 years and older by detailed occupation," (2) EP Table 5.4 "Education and training assignments by detailed occupation," and (3) "job postings data showing what kind of education >requirements employers were seeking for that occupation."
>- The Strada Report tries to avoid what it calls "incumbent worker bias, where workers who have been employed for longer time periods, or who gain regular on-the-job training can skew survey results" (Strada Report, p. 51). Strada is interested in recent (i.e., within 10-years of graduation) graduates.
>- When looking at wages within a given occupation, the STrada Report considers "workers with a terminal bachelor's degree aged 22-27, employed full-time, year-round, and not enrolled in school" (Strada Report, p. 14).

Since I do not have access to the Strada Report's full classification methodology, I use the BLS EP occupation classifications (BLS EP Table 5.4) as a primary reference for testing the Strada Report's claims. THe comparison should be valid since the Strada Report claims its classifications are observationally equivalent to those of the BLS EP results. 

# Methodology
I begin by downloading a cut of the 2022 ACS 5-year sample data (see the "_documentation" subfolder of the repo for more information on variables/observations used). I filtered the data to include only non-student, employed, full-time, year-round, non-military workers.[^3]
[^3]: The exact filtering steps are outlined in the "output/ACS_filtering.txt" document in the repository.

In order to merge the ACS data with the BLS educational requirements from the BLS EP data, I use the BLS-recommended crosswalk. However, as noted by BLS EP Table 5.3, the SOC codes used by the BLS are "not an exact match with ACS,” so the occupations need to be reconciled. The Crosswalk has 832 distinct SOC codes mapped to 525 ACS occupation codes. Thus, there is some duplication of codes in the Crosswalk: **145 ACS occupation codes correspond to multiple SOC codes** (there are 3 SOC codes that map to multiple ACS occupation codes).

To merge the Crosswalk to the ACS Data, I need to assign every ACS occupation code to a unique SOC code. To determine how to assign the ACS occupation codes with multiple corresponding SOC codes, I used the SOC code with the highest level of employment according to the BLS Occupational Employment Wage Statistics ("OEWS") data on employment by SOC code.[^2]
[^2]: For example, the ACS occupation code 335 ("Entertainment and recreation managers") corresponds to two SOC codes: "Gambling managers" (4,590 jobs) and "Entertainment and recreation managers, except gambling" (29,690 jobs). Since the latter has higher employment, I assign it to ACS occupation code 535. 

Once I assigned each ACS occupation code to a unique SOC code, I merged the filtered ACS data and the Crosswalk. I then merged in the BLS Education Requirements to create the final dataset.

# Sources
- ACS Data: https://usa.ipums.org/usa/.
- BLS EP Data: https://www.bls.gov/emp/tables.htm.
- BLS/ACS occupation crosswalk: https://www.bls.gov/emp/classifications-crosswalks/nem-occcode-acs-crosswalk.xlsx. Note that the crosswalk URL is listed in the notes of the Excel file download of the BLS EP tables.
- BLS OEWS employment by SOC code: https://www.bls.gov/oes/current/oes_nat.htm.

# Replication
In order to work with these files, create two local subfolders in the same folder as the "college-underemployment" repository folder: (1) a subfolder titled "IPUMS Data", and (2) a subfolder titled "intermediate". The "IPUMS Data" subfolder should contain an unzipped .dat file with the variables/observations defined in the "_documentation" subfolder of the repository.
