# Overview
This repository hosts analysis done on the most recent ACS 5-yr sample data exploring the education levels and wages of workers in BLS-defined occupations. Incorporated into this analysis is the BLS definition of the "typical" education level required for entry into these occupations, using data from the [BLS Employment Projections](https://www.bls.gov/emp/tables.htm) ("EP") tables as well as occupation counts data from the BLS Occupational Employment Wage Statistics ("OEWS") [data series](https://www.bls.gov/oes/current/oes_nat.htm).

With a focus on AA, BA, or MA workers, this analysis shows that the choice of underemployment definition has a significant impact on the share of workers who are considered underemployed. One option, the **Education Requirements** definition, counts a worker as underemployed if that worker has higher educational attainment than necessary for holding a job in a particular occupation, as defined by the BLS EP tables.[^1] A second option, the **Occupational Wage Premium** definition, adds the criteria that a worker must also earn less than a 5% wage premium per additional year of schooling over the BLS “requirement” to be considered underemployed.[^2]
[^1]: *See*, BLS EP [Table 5.4](https://www.bls.gov/emp/tables/education-and-training-by-occupation.htm).
[^2]: We assume that post-high school, students spend 2 years for an AA, 4 years for a BA, and 6 years for an MA. The wage of the overeducated worker is compared to the median wage of workers in the same occupation who have the BLS “required” level of educational attainment.

# Replication
In order to work with these files, create two local subfolders in the same folder as the "college-underemployment" repository folder: (1) a subfolder titled "IPUMS Data", and (2) a subfolder titled "intermediate". The "IPUMS Data" subfolder should contain an unzipped .dat file with the variables/observations defined in the "[_documentation](https://github.com/mattmtz/college-underemployment/tree/main/_documentation)" subfolder of the repository. In the "code" subfolder, file "00_SETUP.do", change the name of the global variable "IPUMS" to match the name of the current .dat file.

 The "intermediate" folder should remain empty; it will be populated once the code is run.

# Primary Results
For prime-aged workers (25-54), the Education Requirements definition suggests that 37% of BA holders (as well as 65% of AA holders and a startling 87% of MA holders) are underemployed. However, when taking wage premia into account, these figures decrease significantly:[^3]
[^3]: This 37% is only a bit higher than the NY Fed [calculates](https://www.newyorkfed.org/research/college-labor-market#--:explore:underemployment) (32-34% between 2018 and 2022 for BA+ workers aged 22-65).

![fig1](https://raw.githubusercontent.com/mattmtz/college-underemployment/main/output/underemp_summary_by_def.png)

>[!NOTE]
>For context, consider the overall distribution of AA, BA, and MA workers across occupations, grouped by their corresponding BLS-defined requirements for entry (where the "Other" category includes the "some college" and "nondegree award" BLS categories):
> ![fig2](https://raw.githubusercontent.com/mattmtz/college-underemployment/main/output/worker_shares_by_occ_category.png)

# Dataset Creation Methodology
I begin by downloading a cut of the 2022 ACS 5-year sample data (see the "[_documentation](https://github.com/mattmtz/college-underemployment/tree/main/_documentation)" subfolder of the repo for more information on variables/observations used) from [IPUMS](https://usa.ipums.org/usa/). I filtered the data to non-student, employed, full-time, year-round, non-military workers with non-zero wages, aged 22-64.[^4]
[^4]: The log file is given in the "[output/ACS_filtering.txt](https://github.com/mattmtz/college-underemployment/blob/main/output/ACS_filtering.txt)" document in the repository.

![filtering_steps](https://raw.githubusercontent.com/mattmtz/college-underemployment/main/output/acs_filtering_table.png)

In order to merge the ACS data with the BLS educational requirements from the BLS EP data, I use the BLS-recommended [crosswalk](https://www.bls.gov/emp/classifications-crosswalks/nem-occcode-acs-crosswalk.xlsx)[^5] (the "Crosswalk"). However, as noted by BLS EP Table 5.3, the SOC codes used by the BLS are "not an exact match with ACS,” so the occupations need to be reconciled. The Crosswalk has 832 distinct SOC codes mapped to 525 ACS occupation codes. Thus, there is some duplication of codes in the Crosswalk: **145 ACS occupation codes correspond to multiple SOC codes** (there are 3 SOC codes that map to multiple ACS occupation codes).
[^5]: Note that the crosswalk URL is listed in the notes of the Excel file download of the BLS EP tables.

To merge the Crosswalk to the ACS Data, I need to assign every ACS occupation code to a unique SOC code. To determine how to assign the ACS occupation codes with multiple corresponding SOC codes, I used the SOC code with the highest level of employment according to the BLS OEWS data on employment by SOC code.[^6]
[^6]: For example, the ACS occupation code 335 ("Entertainment and recreation managers") corresponds to two SOC codes: "Gambling managers" (4,590 jobs) and "Entertainment and recreation managers, except gambling" (29,690 jobs). Since the latter has higher employment, I assign it to ACS occupation code 535. 

Once I assigned each ACS occupation code to a unique SOC code, I merged the filtered ACS data and the Crosswalk. I then merged in the BLS Education Requirements to create the final dataset.

>[!IMPORTANT]
> In all analyses, occupational data was not conisdered if there were fewer than 75 unweighted observations in the relevant category/categories of workers. For example, when comparing median earnings of 22-27-year-olds in occupations that the BLS defines as requiring an MA, no occupations in this category had 75 or more unweighted observations for workers in these occupations who had PhDs. Thus, we do not report the median earnings for either group (the MAs or the PhDs).
>
>As a simplifying (and conservative) assumption for the Occupational Wage Premium definition of underemployment, we categorize all workers with postsecondary degrees as underemployed if they work in occupations classified by the BLS as requiring less than a high school diploma or a postsecondary non-degree award, regardless of wage premium. This is due to the difficulty in ascertaining an appropriate wage premium for postsecondary degree holders in these occupations. Inclusion of wage premium definitions in these categories would decrease the resulting underemployment rate further relative to the Education Requirements definition.

# Granular Analysis
The table below shows the number of occupations within a given education requirement category that are primarily filled with “overeducated” workers and the associated median earnings for workers with the BLS-required level of educational attainment and for “overeducated” workers. As a first step, we simply compare the median wages of the “overeducated” workers to the workers with the BLS-required level of educational attainment to calculate the median premium for “overeducated” workers:

![table1](https://raw.githubusercontent.com/mattmtz/college-underemployment/main/output/worker_counts_by_occ_and_premium_status.png)

Across all occupation types, over half of “overeducated” workers earn at least the expected premium over their lesser-educated colleagues, based on rows [8], [14], and [20] of the table above.

Turning to analysis of wage premia, the table below shows the number of occupations within a given education requirement category that are primarily filled with “overeducated” workers and the associated median earnings for workers with the BLS-required level of educational attainment and for “overeducated” workers. As a first step, we simply compare the median wages of the “overeducated” workers to the workers with the BLS-required level of educational attainment to calculate the median premium for “overeducated” workers:

![table2](https://raw.githubusercontent.com/mattmtz/college-underemployment/main/output/occ_composition_and_wages_by_overeduc.png)

**KEY TAKEAWAYS FROM TABLE**
* Most occupations with BLS category “No formal credential” have >50% of workers who are “overeducated” (considered “underemployed”). 
* The premia for overeducated workers in the “HS or equivalent” category are consistently higher than the jobs defined as “No formal credential”, “Some college”, and “Associate’s”. There are around 100 occupations in this category that are primarily filled by “overeducated” workers, which suggests a more nuanced approach than the Education Requirements definition of underemployment.
* Occupations defined as “Associate’s” seem to have a significant tenure effect on wages (the premium for overeducation is low for the young workers but steadily increases).
* Some of the highest premia are for overeducated workers in occupations that “require” a bachelor’s or master’s degree. This makes intuitive sense, since these occupations seem to be more analytic; workers with even higher educational attainment applying for jobs may be getting managerial or other more senior roles within a given occupation.

A similar analysis can be performed based on BA+ attainment, as shown below. Once again, regardless of the BLS-defined “requirement” for educational attainment, BA+ holders enjoy a significant wage premium over coworkers with less educational attainment.

![table3](https://raw.githubusercontent.com/mattmtz/college-underemployment/main/output/occ_composition_and_wages_by_BAplus.png)

**KEY TAKEAWAYS FROM TABLE**
* The premia reported in above are generally higher than those reported in the prior table. This shows that there is a major premium associated with at least a BA. These premia are generally robust across age groups – including the “Recent Grads” category – indicating that the returns to these higher levels of educational attainment are immediate and generally permanent.
* There is a steep drop in BA+ earnings from the BLS-defined “Bachelor’s” occupations to the “Master’s” occupations. This is partially due to sampling: high-earning occupations in this category – such as economists, computer scientists, and nurse anesthetists – do not have sufficient observations for BA- workers. The median wage across these excluded high-earning occupations is $81,363 for workers aged 25-54. Another reason for this drop is that the BA+ group includes technically “undereducated” workers by the BLS standards for this category, since those with only a BA count in the BA+ group even when considering “MA-level” occupations.
* The average share of BA+ workers increases steadily with rising BLS-defined education requirements. This shows that the BLS definitions are not completely divorced from occupational compositions.
