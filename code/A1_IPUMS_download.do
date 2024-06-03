cd "..\IPUMS Data"
clear
quietly infix                 ///
  int     year       1-4      ///
  int     multyear   5-8      ///
  long    sample     9-14     ///
  double  serial     15-22    ///
  double  cbserial   23-35    ///
  double  hhwt       36-45    ///
  double  cluster    46-58    ///
  double  strata     59-70    ///
  byte    gq         71-71    ///
  int     pernum     72-75    ///
  double  perwt      76-85    ///
  byte    sex        86-86    ///
  int     age        87-89    ///
  byte    race       90-90    ///
  int     raced      91-93    ///
  byte    hispan     94-94    ///
  int     hispand    95-97    ///
  byte    school     98-98    ///
  byte    educ       99-100   ///
  int     educd      101-103  ///
  byte    degfield   104-105  ///
  int     degfieldd  106-109  ///
  byte    empstat    110-110  ///
  byte    empstatd   111-112  ///
  byte    labforce   113-113  ///
  int     occ        114-117  ///
  int     occ2010    118-121  ///
  str     occsoc     122-127  ///
  int     ind        128-131  ///
  byte    wkswork2   132-132  ///
  byte    uhrswork   133-134  ///
  long    inctot     135-141  ///
  long    incwage    142-147  ///
  using "$IPUMS"

replace hhwt      = hhwt      / 100
replace perwt     = perwt     / 100

format serial    %8.0f
format cbserial  %13.0f
format hhwt      %10.2f
format cluster   %13.0f
format strata    %12.0f
format perwt     %10.2f

label var year      `"Census year"'
label var multyear  `"Actual year of survey, multi-year ACS/PRCS"'
label var sample    `"IPUMS sample identifier"'
label var serial    `"Household serial number"'
label var cbserial  `"Original Census Bureau household serial number"'
label var hhwt      `"Household weight"'
label var cluster   `"Household cluster for variance estimation"'
label var strata    `"Household strata for variance estimation"'
label var gq        `"Group quarters status"'
label var pernum    `"Person number in sample unit"'
label var perwt     `"Person weight"'
label var sex       `"Sex"'
label var age       `"Age"'
label var race      `"Race [general version]"'
label var raced     `"Race [detailed version]"'
label var hispan    `"Hispanic origin [general version]"'
label var hispand   `"Hispanic origin [detailed version]"'
label var school    `"School attendance"'
label var educ      `"Educational attainment [general version]"'
label var educd     `"Educational attainment [detailed version]"'
label var degfield  `"Field of degree [general version]"'
label var degfieldd `"Field of degree [detailed version]"'
label var empstat   `"Employment status [general version]"'
label var empstatd  `"Employment status [detailed version]"'
label var labforce  `"Labor force status"'
label var occ       `"Occupation"'
label var occ2010   `"Occupation, 2010 basis"'
label var occsoc    `"Occupation, SOC classification"'
label var ind       `"Industry"'
label var wkswork2  `"Weeks worked last year, intervalled"'
label var uhrswork  `"Usual hours worked per week"'
label var inctot    `"Total personal income"'
label var incwage   `"Wage and salary income"'

label define year_lbl 1850 `"1850"'
label define year_lbl 1860 `"1860"', add
label define year_lbl 1870 `"1870"', add
label define year_lbl 1880 `"1880"', add
label define year_lbl 1900 `"1900"', add
label define year_lbl 1910 `"1910"', add
label define year_lbl 1920 `"1920"', add
label define year_lbl 1930 `"1930"', add
label define year_lbl 1940 `"1940"', add
label define year_lbl 1950 `"1950"', add
label define year_lbl 1960 `"1960"', add
label define year_lbl 1970 `"1970"', add
label define year_lbl 1980 `"1980"', add
label define year_lbl 1990 `"1990"', add
label define year_lbl 2000 `"2000"', add
label define year_lbl 2001 `"2001"', add
label define year_lbl 2002 `"2002"', add
label define year_lbl 2003 `"2003"', add
label define year_lbl 2004 `"2004"', add
label define year_lbl 2005 `"2005"', add
label define year_lbl 2006 `"2006"', add
label define year_lbl 2007 `"2007"', add
label define year_lbl 2008 `"2008"', add
label define year_lbl 2009 `"2009"', add
label define year_lbl 2010 `"2010"', add
label define year_lbl 2011 `"2011"', add
label define year_lbl 2012 `"2012"', add
label define year_lbl 2013 `"2013"', add
label define year_lbl 2014 `"2014"', add
label define year_lbl 2015 `"2015"', add
label define year_lbl 2016 `"2016"', add
label define year_lbl 2017 `"2017"', add
label define year_lbl 2018 `"2018"', add
label define year_lbl 2019 `"2019"', add
label define year_lbl 2020 `"2020"', add
label define year_lbl 2021 `"2021"', add
label define year_lbl 2022 `"2022"', add
label values year year_lbl

label define sample_lbl 202204 `"2018-2022, PRCS 5-year"'
label define sample_lbl 202203 `"2018-2022, ACS 5-year"', add
label define sample_lbl 202202 `"2022 PRCS"', add
label define sample_lbl 202201 `"2022 ACS"', add
label define sample_lbl 202104 `"2017-2021, PRCS 5-year"', add
label define sample_lbl 202103 `"2017-2021, ACS 5-year"', add
label define sample_lbl 202102 `"2021 PRCS"', add
label define sample_lbl 202101 `"2021 ACS"', add
label define sample_lbl 202004 `"2016-2020, PRCS 5-year"', add
label define sample_lbl 202003 `"2016-2020, ACS 5-year"', add
label define sample_lbl 202001 `"2020 ACS"', add
label define sample_lbl 201904 `"2015-2019, PRCS 5-year"', add
label define sample_lbl 201903 `"2015-2019, ACS 5-year"', add
label define sample_lbl 201902 `"2019 PRCS"', add
label define sample_lbl 201901 `"2019 ACS"', add
label define sample_lbl 201804 `"2014-2018, PRCS 5-year"', add
label define sample_lbl 201803 `"2014-2018, ACS 5-year"', add
label define sample_lbl 201802 `"2018 PRCS"', add
label define sample_lbl 201801 `"2018 ACS"', add
label define sample_lbl 201704 `"2013-2017, PRCS 5-year"', add
label define sample_lbl 201703 `"2013-2017, ACS 5-year"', add
label define sample_lbl 201702 `"2017 PRCS"', add
label define sample_lbl 201701 `"2017 ACS"', add
label define sample_lbl 201604 `"2012-2016, PRCS 5-year"', add
label define sample_lbl 201603 `"2012-2016, ACS 5-year"', add
label define sample_lbl 201602 `"2016 PRCS"', add
label define sample_lbl 201601 `"2016 ACS"', add
label define sample_lbl 201504 `"2011-2015, PRCS 5-year"', add
label define sample_lbl 201503 `"2011-2015, ACS 5-year"', add
label define sample_lbl 201502 `"2015 PRCS"', add
label define sample_lbl 201501 `"2015 ACS"', add
label define sample_lbl 201404 `"2010-2014, PRCS 5-year"', add
label define sample_lbl 201403 `"2010-2014, ACS 5-year"', add
label define sample_lbl 201402 `"2014 PRCS"', add
label define sample_lbl 201401 `"2014 ACS"', add
label define sample_lbl 201306 `"2009-2013, PRCS 5-year"', add
label define sample_lbl 201305 `"2009-2013, ACS 5-year"', add
label define sample_lbl 201304 `"2011-2013, PRCS 3-year"', add
label define sample_lbl 201303 `"2011-2013, ACS 3-year"', add
label define sample_lbl 201302 `"2013 PRCS"', add
label define sample_lbl 201301 `"2013 ACS"', add
label define sample_lbl 201206 `"2008-2012, PRCS 5-year"', add
label define sample_lbl 201205 `"2008-2012, ACS 5-year"', add
label define sample_lbl 201204 `"2010-2012, PRCS 3-year"', add
label define sample_lbl 201203 `"2010-2012, ACS 3-year"', add
label define sample_lbl 201202 `"2012 PRCS"', add
label define sample_lbl 201201 `"2012 ACS"', add
label define sample_lbl 201106 `"2007-2011, PRCS 5-year"', add
label define sample_lbl 201105 `"2007-2011, ACS 5-year"', add
label define sample_lbl 201104 `"2009-2011, PRCS 3-year"', add
label define sample_lbl 201103 `"2009-2011, ACS 3-year"', add
label define sample_lbl 201102 `"2011 PRCS"', add
label define sample_lbl 201101 `"2011 ACS"', add
label define sample_lbl 201008 `"2010 Puerto Rico 10%"', add
label define sample_lbl 201007 `"2010 10%"', add
label define sample_lbl 201006 `"2006-2010, PRCS 5-year"', add
label define sample_lbl 201005 `"2006-2010, ACS 5-year"', add
label define sample_lbl 201004 `"2008-2010, PRCS 3-year"', add
label define sample_lbl 201003 `"2008-2010, ACS 3-year"', add
label define sample_lbl 201002 `"2010 PRCS"', add
label define sample_lbl 201001 `"2010 ACS"', add
label define sample_lbl 200906 `"2005-2009, PRCS 5-year"', add
label define sample_lbl 200905 `"2005-2009, ACS 5-year"', add
label define sample_lbl 200904 `"2007-2009, PRCS 3-year"', add
label define sample_lbl 200903 `"2007-2009, ACS 3-year"', add
label define sample_lbl 200902 `"2009 PRCS"', add
label define sample_lbl 200901 `"2009 ACS"', add
label define sample_lbl 200804 `"2006-2008, PRCS 3-year"', add
label define sample_lbl 200803 `"2006-2008, ACS 3-year"', add
label define sample_lbl 200802 `"2008 PRCS"', add
label define sample_lbl 200801 `"2008 ACS"', add
label define sample_lbl 200704 `"2005-2007, PRCS 3-year"', add
label define sample_lbl 200703 `"2005-2007, ACS 3-year"', add
label define sample_lbl 200702 `"2007 PRCS"', add
label define sample_lbl 200701 `"2007 ACS"', add
label define sample_lbl 200602 `"2006 PRCS"', add
label define sample_lbl 200601 `"2006 ACS"', add
label define sample_lbl 200502 `"2005 PRCS"', add
label define sample_lbl 200501 `"2005 ACS"', add
label define sample_lbl 200401 `"2004 ACS"', add
label define sample_lbl 200301 `"2003 ACS"', add
label define sample_lbl 200201 `"2002 ACS"', add
label define sample_lbl 200101 `"2001 ACS"', add
label define sample_lbl 200008 `"2000 Puerto Rico 1%"', add
label define sample_lbl 200007 `"2000 1%"', add
label define sample_lbl 200006 `"2000 Puerto Rico 1% sample (old version)"', add
label define sample_lbl 200005 `"2000 Puerto Rico 5%"', add
label define sample_lbl 200004 `"2000 ACS"', add
label define sample_lbl 200003 `"2000 Unweighted 1%"', add
label define sample_lbl 200002 `"2000 1% sample (old version)"', add
label define sample_lbl 200001 `"2000 5%"', add
label define sample_lbl 199007 `"1990 Puerto Rico 1%"', add
label define sample_lbl 199006 `"1990 Puerto Rico 5%"', add
label define sample_lbl 199005 `"1990 Labor Market Area"', add
label define sample_lbl 199004 `"1990 Elderly"', add
label define sample_lbl 199003 `"1990 Unweighted 1%"', add
label define sample_lbl 199002 `"1990 1%"', add
label define sample_lbl 199001 `"1990 5%"', add
label define sample_lbl 198007 `"1980 Puerto Rico 1%"', add
label define sample_lbl 198006 `"1980 Puerto Rico 5%"', add
label define sample_lbl 198005 `"1980 Detailed metro/non-metro"', add
label define sample_lbl 198004 `"1980 Labor Market Area"', add
label define sample_lbl 198003 `"1980 Urban/Rural"', add
label define sample_lbl 198002 `"1980 1%"', add
label define sample_lbl 198001 `"1980 5%"', add
label define sample_lbl 197009 `"1970 Puerto Rico Neighborhood"', add
label define sample_lbl 197008 `"1970 Puerto Rico Municipio"', add
label define sample_lbl 197007 `"1970 Puerto Rico State"', add
label define sample_lbl 197006 `"1970 Form 2 Neighborhood"', add
label define sample_lbl 197005 `"1970 Form 1 Neighborhood"', add
label define sample_lbl 197004 `"1970 Form 2 Metro"', add
label define sample_lbl 197003 `"1970 Form 1 Metro"', add
label define sample_lbl 197002 `"1970 Form 2 State"', add
label define sample_lbl 197001 `"1970 Form 1 State"', add
label define sample_lbl 196002 `"1960 5%"', add
label define sample_lbl 196001 `"1960 1%"', add
label define sample_lbl 195002 `"1950 100% database"', add
label define sample_lbl 195001 `"1950 1%"', add
label define sample_lbl 194002 `"1940 100% database"', add
label define sample_lbl 194001 `"1940 1%"', add
label define sample_lbl 193004 `"1930 100% database"', add
label define sample_lbl 193003 `"1930 Puerto Rico"', add
label define sample_lbl 193002 `"1930 5%"', add
label define sample_lbl 193001 `"1930 1%"', add
label define sample_lbl 192003 `"1920 100% database"', add
label define sample_lbl 192002 `"1920 Puerto Rico sample"', add
label define sample_lbl 192001 `"1920 1%"', add
label define sample_lbl 191004 `"1910 100% database"', add
label define sample_lbl 191003 `"1910 1.4% sample with oversamples"', add
label define sample_lbl 191002 `"1910 1%"', add
label define sample_lbl 191001 `"1910 Puerto Rico"', add
label define sample_lbl 190004 `"1900 100% database"', add
label define sample_lbl 190003 `"1900 1% sample with oversamples"', add
label define sample_lbl 190002 `"1900 1%"', add
label define sample_lbl 190001 `"1900 5%"', add
label define sample_lbl 188003 `"1880 100% database"', add
label define sample_lbl 188002 `"1880 10%"', add
label define sample_lbl 188001 `"1880 1%"', add
label define sample_lbl 187003 `"1870 100% database"', add
label define sample_lbl 187002 `"1870 1% sample with black oversample"', add
label define sample_lbl 187001 `"1870 1%"', add
label define sample_lbl 186003 `"1860 100% database"', add
label define sample_lbl 186002 `"1860 1% sample with black oversample"', add
label define sample_lbl 186001 `"1860 1%"', add
label define sample_lbl 185002 `"1850 100% database"', add
label define sample_lbl 185001 `"1850 1%"', add
label values sample sample_lbl

label define gq_lbl 0 `"Vacant unit"'
label define gq_lbl 1 `"Households under 1970 definition"', add
label define gq_lbl 2 `"Additional households under 1990 definition"', add
label define gq_lbl 3 `"Group quarters--Institutions"', add
label define gq_lbl 4 `"Other group quarters"', add
label define gq_lbl 5 `"Additional households under 2000 definition"', add
label define gq_lbl 6 `"Fragment"', add
label values gq gq_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label define sex_lbl 9 `"Missing/blank"', add
label values sex sex_lbl

label define age_lbl 000 `"Less than 1 year old"'
label define age_lbl 001 `"1"', add
label define age_lbl 002 `"2"', add
label define age_lbl 003 `"3"', add
label define age_lbl 004 `"4"', add
label define age_lbl 005 `"5"', add
label define age_lbl 006 `"6"', add
label define age_lbl 007 `"7"', add
label define age_lbl 008 `"8"', add
label define age_lbl 009 `"9"', add
label define age_lbl 010 `"10"', add
label define age_lbl 011 `"11"', add
label define age_lbl 012 `"12"', add
label define age_lbl 013 `"13"', add
label define age_lbl 014 `"14"', add
label define age_lbl 015 `"15"', add
label define age_lbl 016 `"16"', add
label define age_lbl 017 `"17"', add
label define age_lbl 018 `"18"', add
label define age_lbl 019 `"19"', add
label define age_lbl 020 `"20"', add
label define age_lbl 021 `"21"', add
label define age_lbl 022 `"22"', add
label define age_lbl 023 `"23"', add
label define age_lbl 024 `"24"', add
label define age_lbl 025 `"25"', add
label define age_lbl 026 `"26"', add
label define age_lbl 027 `"27"', add
label define age_lbl 028 `"28"', add
label define age_lbl 029 `"29"', add
label define age_lbl 030 `"30"', add
label define age_lbl 031 `"31"', add
label define age_lbl 032 `"32"', add
label define age_lbl 033 `"33"', add
label define age_lbl 034 `"34"', add
label define age_lbl 035 `"35"', add
label define age_lbl 036 `"36"', add
label define age_lbl 037 `"37"', add
label define age_lbl 038 `"38"', add
label define age_lbl 039 `"39"', add
label define age_lbl 040 `"40"', add
label define age_lbl 041 `"41"', add
label define age_lbl 042 `"42"', add
label define age_lbl 043 `"43"', add
label define age_lbl 044 `"44"', add
label define age_lbl 045 `"45"', add
label define age_lbl 046 `"46"', add
label define age_lbl 047 `"47"', add
label define age_lbl 048 `"48"', add
label define age_lbl 049 `"49"', add
label define age_lbl 050 `"50"', add
label define age_lbl 051 `"51"', add
label define age_lbl 052 `"52"', add
label define age_lbl 053 `"53"', add
label define age_lbl 054 `"54"', add
label define age_lbl 055 `"55"', add
label define age_lbl 056 `"56"', add
label define age_lbl 057 `"57"', add
label define age_lbl 058 `"58"', add
label define age_lbl 059 `"59"', add
label define age_lbl 060 `"60"', add
label define age_lbl 061 `"61"', add
label define age_lbl 062 `"62"', add
label define age_lbl 063 `"63"', add
label define age_lbl 064 `"64"', add
label define age_lbl 065 `"65"', add
label define age_lbl 066 `"66"', add
label define age_lbl 067 `"67"', add
label define age_lbl 068 `"68"', add
label define age_lbl 069 `"69"', add
label define age_lbl 070 `"70"', add
label define age_lbl 071 `"71"', add
label define age_lbl 072 `"72"', add
label define age_lbl 073 `"73"', add
label define age_lbl 074 `"74"', add
label define age_lbl 075 `"75"', add
label define age_lbl 076 `"76"', add
label define age_lbl 077 `"77"', add
label define age_lbl 078 `"78"', add
label define age_lbl 079 `"79"', add
label define age_lbl 080 `"80"', add
label define age_lbl 081 `"81"', add
label define age_lbl 082 `"82"', add
label define age_lbl 083 `"83"', add
label define age_lbl 084 `"84"', add
label define age_lbl 085 `"85"', add
label define age_lbl 086 `"86"', add
label define age_lbl 087 `"87"', add
label define age_lbl 088 `"88"', add
label define age_lbl 089 `"89"', add
label define age_lbl 090 `"90 (90+ in 1980 and 1990)"', add
label define age_lbl 091 `"91"', add
label define age_lbl 092 `"92"', add
label define age_lbl 093 `"93"', add
label define age_lbl 094 `"94"', add
label define age_lbl 095 `"95"', add
label define age_lbl 096 `"96"', add
label define age_lbl 097 `"97"', add
label define age_lbl 098 `"98"', add
label define age_lbl 099 `"99"', add
label define age_lbl 100 `"100 (100+ in 1960-1970)"', add
label define age_lbl 101 `"101"', add
label define age_lbl 102 `"102"', add
label define age_lbl 103 `"103"', add
label define age_lbl 104 `"104"', add
label define age_lbl 105 `"105"', add
label define age_lbl 106 `"106"', add
label define age_lbl 107 `"107"', add
label define age_lbl 108 `"108"', add
label define age_lbl 109 `"109"', add
label define age_lbl 110 `"110"', add
label define age_lbl 111 `"111"', add
label define age_lbl 112 `"112 (112+ in the 1980 internal data)"', add
label define age_lbl 113 `"113"', add
label define age_lbl 114 `"114"', add
label define age_lbl 115 `"115 (115+ in the 1990 internal data)"', add
label define age_lbl 116 `"116"', add
label define age_lbl 117 `"117"', add
label define age_lbl 118 `"118"', add
label define age_lbl 119 `"119"', add
label define age_lbl 120 `"120"', add
label define age_lbl 121 `"121"', add
label define age_lbl 122 `"122"', add
label define age_lbl 123 `"123"', add
label define age_lbl 124 `"124"', add
label define age_lbl 125 `"125"', add
label define age_lbl 126 `"126"', add
label define age_lbl 127 `"127"', add
label define age_lbl 128 `"128"', add
label define age_lbl 129 `"129"', add
label define age_lbl 130 `"130"', add
label define age_lbl 131 `"131"', add
label define age_lbl 132 `"132"', add
label define age_lbl 133 `"133"', add
label define age_lbl 134 `"134"', add
label define age_lbl 135 `"135"', add
label define age_lbl 140 `"140"', add
label define age_lbl 999 `"Missing"', add
label values age age_lbl

label define race_lbl 1 `"White"'
label define race_lbl 2 `"Black/African American"', add
label define race_lbl 3 `"American Indian or Alaska Native"', add
label define race_lbl 4 `"Chinese"', add
label define race_lbl 5 `"Japanese"', add
label define race_lbl 6 `"Other Asian or Pacific Islander"', add
label define race_lbl 7 `"Other race, nec"', add
label define race_lbl 8 `"Two major races"', add
label define race_lbl 9 `"Three or more major races"', add
label values race race_lbl

label define raced_lbl 100 `"White"'
label define raced_lbl 110 `"Spanish write_in"', add
label define raced_lbl 120 `"Blank (white) (1850)"', add
label define raced_lbl 130 `"Portuguese"', add
label define raced_lbl 140 `"Mexican (1930)"', add
label define raced_lbl 150 `"Puerto Rican (1910 Hawaii)"', add
label define raced_lbl 200 `"Black/African American"', add
label define raced_lbl 210 `"Mulatto"', add
label define raced_lbl 300 `"American Indian/Alaska Native"', add
label define raced_lbl 302 `"Apache"', add
label define raced_lbl 303 `"Blackfoot"', add
label define raced_lbl 304 `"Cherokee"', add
label define raced_lbl 305 `"Cheyenne"', add
label define raced_lbl 306 `"Chickasaw"', add
label define raced_lbl 307 `"Chippewa"', add
label define raced_lbl 308 `"Choctaw"', add
label define raced_lbl 309 `"Comanche"', add
label define raced_lbl 310 `"Creek"', add
label define raced_lbl 311 `"Crow"', add
label define raced_lbl 312 `"Iroquois"', add
label define raced_lbl 313 `"Kiowa"', add
label define raced_lbl 314 `"Lumbee"', add
label define raced_lbl 315 `"Navajo"', add
label define raced_lbl 316 `"Osage"', add
label define raced_lbl 317 `"Paiute"', add
label define raced_lbl 318 `"Pima"', add
label define raced_lbl 319 `"Potawatomi"', add
label define raced_lbl 320 `"Pueblo"', add
label define raced_lbl 321 `"Seminole"', add
label define raced_lbl 322 `"Shoshone"', add
label define raced_lbl 323 `"Sioux"', add
label define raced_lbl 324 `"Tlingit (Tlingit_Haida, 2000/ACS)"', add
label define raced_lbl 325 `"Tohono O Odham"', add
label define raced_lbl 326 `"All other tribes (1990)"', add
label define raced_lbl 328 `"Hopi"', add
label define raced_lbl 329 `"Central American Indian"', add
label define raced_lbl 330 `"Spanish American Indian"', add
label define raced_lbl 350 `"Delaware"', add
label define raced_lbl 351 `"Latin American Indian"', add
label define raced_lbl 352 `"Puget Sound Salish"', add
label define raced_lbl 353 `"Yakama"', add
label define raced_lbl 354 `"Yaqui"', add
label define raced_lbl 355 `"Colville"', add
label define raced_lbl 356 `"Houma"', add
label define raced_lbl 357 `"Menominee"', add
label define raced_lbl 358 `"Yuman"', add
label define raced_lbl 359 `"South American Indian"', add
label define raced_lbl 360 `"Mexican American Indian"', add
label define raced_lbl 361 `"Other Amer. Indian tribe (2000,ACS)"', add
label define raced_lbl 362 `"2+ Amer. Indian tribes (2000,ACS)"', add
label define raced_lbl 370 `"Alaskan Athabaskan"', add
label define raced_lbl 371 `"Aleut"', add
label define raced_lbl 372 `"Eskimo"', add
label define raced_lbl 373 `"Alaskan mixed"', add
label define raced_lbl 374 `"Inupiat"', add
label define raced_lbl 375 `"Yup'ik"', add
label define raced_lbl 379 `"Other Alaska Native tribe(s) (2000,ACS)"', add
label define raced_lbl 398 `"Both Am. Ind. and Alaska Native (2000,ACS)"', add
label define raced_lbl 399 `"Tribe not specified"', add
label define raced_lbl 400 `"Chinese"', add
label define raced_lbl 410 `"Taiwanese"', add
label define raced_lbl 420 `"Chinese and Taiwanese"', add
label define raced_lbl 500 `"Japanese"', add
label define raced_lbl 600 `"Filipino"', add
label define raced_lbl 610 `"Asian Indian (Hindu 1920_1940)"', add
label define raced_lbl 620 `"Korean"', add
label define raced_lbl 630 `"Hawaiian"', add
label define raced_lbl 631 `"Hawaiian and Asian (1900,1920)"', add
label define raced_lbl 632 `"Hawaiian and European (1900,1920)"', add
label define raced_lbl 634 `"Hawaiian mixed"', add
label define raced_lbl 640 `"Vietnamese"', add
label define raced_lbl 641 `"Bhutanese"', add
label define raced_lbl 642 `"Mongolian"', add
label define raced_lbl 643 `"Nepalese"', add
label define raced_lbl 650 `"Other Asian or Pacific Islander (1920,1980)"', add
label define raced_lbl 651 `"Asian only (CPS)"', add
label define raced_lbl 652 `"Pacific Islander only (CPS)"', add
label define raced_lbl 653 `"Asian or Pacific Islander, n.s. (1990 Internal Census files)"', add
label define raced_lbl 660 `"Cambodian"', add
label define raced_lbl 661 `"Hmong"', add
label define raced_lbl 662 `"Laotian"', add
label define raced_lbl 663 `"Thai"', add
label define raced_lbl 664 `"Bangladeshi"', add
label define raced_lbl 665 `"Burmese"', add
label define raced_lbl 666 `"Indonesian"', add
label define raced_lbl 667 `"Malaysian"', add
label define raced_lbl 668 `"Okinawan"', add
label define raced_lbl 669 `"Pakistani"', add
label define raced_lbl 670 `"Sri Lankan"', add
label define raced_lbl 671 `"Other Asian, n.e.c."', add
label define raced_lbl 672 `"Asian, not specified"', add
label define raced_lbl 673 `"Chinese and Japanese"', add
label define raced_lbl 674 `"Chinese and Filipino"', add
label define raced_lbl 675 `"Chinese and Vietnamese"', add
label define raced_lbl 676 `"Chinese and Asian write_in"', add
label define raced_lbl 677 `"Japanese and Filipino"', add
label define raced_lbl 678 `"Asian Indian and Asian write_in"', add
label define raced_lbl 679 `"Other Asian race combinations"', add
label define raced_lbl 680 `"Samoan"', add
label define raced_lbl 681 `"Tahitian"', add
label define raced_lbl 682 `"Tongan"', add
label define raced_lbl 683 `"Other Polynesian (1990)"', add
label define raced_lbl 684 `"1+ other Polynesian races (2000,ACS)"', add
label define raced_lbl 685 `"Chamorro"', add
label define raced_lbl 686 `"Northern Mariana Islander"', add
label define raced_lbl 687 `"Palauan"', add
label define raced_lbl 688 `"Other Micronesian (1990)"', add
label define raced_lbl 689 `"1+ other Micronesian races (2000,ACS)"', add
label define raced_lbl 690 `"Fijian"', add
label define raced_lbl 691 `"Other Melanesian (1990)"', add
label define raced_lbl 692 `"1+ other Melanesian races (2000,ACS)"', add
label define raced_lbl 698 `"2+ PI races from 2+ PI regions"', add
label define raced_lbl 699 `"Pacific Islander, n.s."', add
label define raced_lbl 700 `"Other race, n.e.c."', add
label define raced_lbl 801 `"White and Black"', add
label define raced_lbl 802 `"White and AIAN"', add
label define raced_lbl 810 `"White and Asian"', add
label define raced_lbl 811 `"White and Chinese"', add
label define raced_lbl 812 `"White and Japanese"', add
label define raced_lbl 813 `"White and Filipino"', add
label define raced_lbl 814 `"White and Asian Indian"', add
label define raced_lbl 815 `"White and Korean"', add
label define raced_lbl 816 `"White and Vietnamese"', add
label define raced_lbl 817 `"White and Asian write_in"', add
label define raced_lbl 818 `"White and other Asian race(s)"', add
label define raced_lbl 819 `"White and two or more Asian groups"', add
label define raced_lbl 820 `"White and PI"', add
label define raced_lbl 821 `"White and Native Hawaiian"', add
label define raced_lbl 822 `"White and Samoan"', add
label define raced_lbl 823 `"White and Chamorro"', add
label define raced_lbl 824 `"White and PI write_in"', add
label define raced_lbl 825 `"White and other PI race(s)"', add
label define raced_lbl 826 `"White and other race write_in"', add
label define raced_lbl 827 `"White and other race, n.e.c."', add
label define raced_lbl 830 `"Black and AIAN"', add
label define raced_lbl 831 `"Black and Asian"', add
label define raced_lbl 832 `"Black and Chinese"', add
label define raced_lbl 833 `"Black and Japanese"', add
label define raced_lbl 834 `"Black and Filipino"', add
label define raced_lbl 835 `"Black and Asian Indian"', add
label define raced_lbl 836 `"Black and Korean"', add
label define raced_lbl 837 `"Black and Asian write_in"', add
label define raced_lbl 838 `"Black and other Asian race(s)"', add
label define raced_lbl 840 `"Black and PI"', add
label define raced_lbl 841 `"Black and PI write_in"', add
label define raced_lbl 842 `"Black and other PI race(s)"', add
label define raced_lbl 845 `"Black and other race write_in"', add
label define raced_lbl 850 `"AIAN and Asian"', add
label define raced_lbl 851 `"AIAN and Filipino (2000 1%)"', add
label define raced_lbl 852 `"AIAN and Asian Indian"', add
label define raced_lbl 853 `"AIAN and Asian write_in (2000 1%)"', add
label define raced_lbl 854 `"AIAN and other Asian race(s)"', add
label define raced_lbl 855 `"AIAN and PI"', add
label define raced_lbl 856 `"AIAN and other race write_in"', add
label define raced_lbl 860 `"Asian and PI"', add
label define raced_lbl 861 `"Chinese and Hawaiian"', add
label define raced_lbl 862 `"Chinese, Filipino, Hawaiian (2000 1%)"', add
label define raced_lbl 863 `"Japanese and Hawaiian (2000 1%)"', add
label define raced_lbl 864 `"Filipino and Hawaiian"', add
label define raced_lbl 865 `"Filipino and PI write_in"', add
label define raced_lbl 866 `"Asian Indian and PI write_in (2000 1%)"', add
label define raced_lbl 867 `"Asian write_in and PI write_in"', add
label define raced_lbl 868 `"Other Asian race(s) and PI race(s)"', add
label define raced_lbl 869 `"Japanese and Korean (ACS)"', add
label define raced_lbl 880 `"Asian and other race write_in"', add
label define raced_lbl 881 `"Chinese and other race write_in"', add
label define raced_lbl 882 `"Japanese and other race write_in"', add
label define raced_lbl 883 `"Filipino and other race write_in"', add
label define raced_lbl 884 `"Asian Indian and other race write_in"', add
label define raced_lbl 885 `"Asian write_in and other race write_in"', add
label define raced_lbl 886 `"Other Asian race(s) and other race write_in"', add
label define raced_lbl 887 `"Chinese and Korean"', add
label define raced_lbl 890 `"PI and other race write_in:"', add
label define raced_lbl 891 `"PI write_in and other race write_in"', add
label define raced_lbl 892 `"Other PI race(s) and other race write_in"', add
label define raced_lbl 893 `"Native Hawaiian or PI other race(s)"', add
label define raced_lbl 899 `"API and other race write_in"', add
label define raced_lbl 901 `"White, Black, AIAN"', add
label define raced_lbl 902 `"White, Black, Asian"', add
label define raced_lbl 903 `"White, Black, PI"', add
label define raced_lbl 904 `"White, Black, other race write_in"', add
label define raced_lbl 905 `"White, AIAN, Asian"', add
label define raced_lbl 906 `"White, AIAN, PI"', add
label define raced_lbl 907 `"White, AIAN, other race write_in"', add
label define raced_lbl 910 `"White, Asian, PI"', add
label define raced_lbl 911 `"White, Chinese, Hawaiian"', add
label define raced_lbl 912 `"White, Chinese, Filipino, Hawaiian (2000 1%)"', add
label define raced_lbl 913 `"White, Japanese, Hawaiian (2000 1%)"', add
label define raced_lbl 914 `"White, Filipino, Hawaiian"', add
label define raced_lbl 915 `"Other White, Asian race(s), PI race(s)"', add
label define raced_lbl 916 `"White, AIAN and Filipino"', add
label define raced_lbl 917 `"White, Black, and Filipino"', add
label define raced_lbl 920 `"White, Asian, other race write_in"', add
label define raced_lbl 921 `"White, Filipino, other race write_in (2000 1%)"', add
label define raced_lbl 922 `"White, Asian write_in, other race write_in (2000 1%)"', add
label define raced_lbl 923 `"Other White, Asian race(s), other race write_in (2000 1%)"', add
label define raced_lbl 925 `"White, PI, other race write_in"', add
label define raced_lbl 930 `"Black, AIAN, Asian"', add
label define raced_lbl 931 `"Black, AIAN, PI"', add
label define raced_lbl 932 `"Black, AIAN, other race write_in"', add
label define raced_lbl 933 `"Black, Asian, PI"', add
label define raced_lbl 934 `"Black, Asian, other race write_in"', add
label define raced_lbl 935 `"Black, PI, other race write_in"', add
label define raced_lbl 940 `"AIAN, Asian, PI"', add
label define raced_lbl 941 `"AIAN, Asian, other race write_in"', add
label define raced_lbl 942 `"AIAN, PI, other race write_in"', add
label define raced_lbl 943 `"Asian, PI, other race write_in"', add
label define raced_lbl 944 `"Asian (Chinese, Japanese, Korean, Vietnamese); and Native Hawaiian or PI; and Other"', add
label define raced_lbl 949 `"2 or 3 races (CPS)"', add
label define raced_lbl 950 `"White, Black, AIAN, Asian"', add
label define raced_lbl 951 `"White, Black, AIAN, PI"', add
label define raced_lbl 952 `"White, Black, AIAN, other race write_in"', add
label define raced_lbl 953 `"White, Black, Asian, PI"', add
label define raced_lbl 954 `"White, Black, Asian, other race write_in"', add
label define raced_lbl 955 `"White, Black, PI, other race write_in"', add
label define raced_lbl 960 `"White, AIAN, Asian, PI"', add
label define raced_lbl 961 `"White, AIAN, Asian, other race write_in"', add
label define raced_lbl 962 `"White, AIAN, PI, other race write_in"', add
label define raced_lbl 963 `"White, Asian, PI, other race write_in"', add
label define raced_lbl 964 `"White, Chinese, Japanese, Native Hawaiian"', add
label define raced_lbl 970 `"Black, AIAN, Asian, PI"', add
label define raced_lbl 971 `"Black, AIAN, Asian, other race write_in"', add
label define raced_lbl 972 `"Black, AIAN, PI, other race write_in"', add
label define raced_lbl 973 `"Black, Asian, PI, other race write_in"', add
label define raced_lbl 974 `"AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 975 `"AIAN, Asian, PI, Hawaiian other race write_in"', add
label define raced_lbl 976 `"Two specified Asian  (Chinese and other Asian, Chinese and Japanese, Japanese and other Asian, Korean and other Asian); Native Hawaiian/PI; and Other Race"', add
label define raced_lbl 980 `"White, Black, AIAN, Asian, PI"', add
label define raced_lbl 981 `"White, Black, AIAN, Asian, other race write_in"', add
label define raced_lbl 982 `"White, Black, AIAN, PI, other race write_in"', add
label define raced_lbl 983 `"White, Black, Asian, PI, other race write_in"', add
label define raced_lbl 984 `"White, AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 985 `"Black, AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 986 `"Black, AIAN, Asian, PI, Hawaiian, other race write_in"', add
label define raced_lbl 989 `"4 or 5 races (CPS)"', add
label define raced_lbl 990 `"White, Black, AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 991 `"White race; Some other race; Black or African American race and/or American Indian and Alaska Native race and/or Asian groups and/or Native Hawaiian and Other Pacific Islander groups"', add
label define raced_lbl 996 `"2+ races, n.e.c. (CPS)"', add
label define raced_lbl 997 `"Unknown"', add
label values raced raced_lbl

label define hispan_lbl 0 `"Not Hispanic"'
label define hispan_lbl 1 `"Mexican"', add
label define hispan_lbl 2 `"Puerto Rican"', add
label define hispan_lbl 3 `"Cuban"', add
label define hispan_lbl 4 `"Other"', add
label define hispan_lbl 9 `"Not Reported"', add
label values hispan hispan_lbl

label define hispand_lbl 000 `"Not Hispanic"'
label define hispand_lbl 100 `"Mexican"', add
label define hispand_lbl 102 `"Mexican American"', add
label define hispand_lbl 103 `"Mexicano/Mexicana"', add
label define hispand_lbl 104 `"Chicano/Chicana"', add
label define hispand_lbl 105 `"La Raza"', add
label define hispand_lbl 106 `"Mexican American Indian"', add
label define hispand_lbl 107 `"Mexico"', add
label define hispand_lbl 200 `"Puerto Rican"', add
label define hispand_lbl 300 `"Cuban"', add
label define hispand_lbl 401 `"Central American Indian"', add
label define hispand_lbl 402 `"Canal Zone"', add
label define hispand_lbl 411 `"Costa Rican"', add
label define hispand_lbl 412 `"Guatemalan"', add
label define hispand_lbl 413 `"Honduran"', add
label define hispand_lbl 414 `"Nicaraguan"', add
label define hispand_lbl 415 `"Panamanian"', add
label define hispand_lbl 416 `"Salvadoran"', add
label define hispand_lbl 417 `"Central American, n.e.c."', add
label define hispand_lbl 420 `"Argentinean"', add
label define hispand_lbl 421 `"Bolivian"', add
label define hispand_lbl 422 `"Chilean"', add
label define hispand_lbl 423 `"Colombian"', add
label define hispand_lbl 424 `"Ecuadorian"', add
label define hispand_lbl 425 `"Paraguayan"', add
label define hispand_lbl 426 `"Peruvian"', add
label define hispand_lbl 427 `"Uruguayan"', add
label define hispand_lbl 428 `"Venezuelan"', add
label define hispand_lbl 429 `"South American Indian"', add
label define hispand_lbl 430 `"Criollo"', add
label define hispand_lbl 431 `"South American, n.e.c."', add
label define hispand_lbl 450 `"Spaniard"', add
label define hispand_lbl 451 `"Andalusian"', add
label define hispand_lbl 452 `"Asturian"', add
label define hispand_lbl 453 `"Castillian"', add
label define hispand_lbl 454 `"Catalonian"', add
label define hispand_lbl 455 `"Balearic Islander"', add
label define hispand_lbl 456 `"Gallego"', add
label define hispand_lbl 457 `"Valencian"', add
label define hispand_lbl 458 `"Canarian"', add
label define hispand_lbl 459 `"Spanish Basque"', add
label define hispand_lbl 460 `"Dominican"', add
label define hispand_lbl 465 `"Latin American"', add
label define hispand_lbl 470 `"Hispanic"', add
label define hispand_lbl 480 `"Spanish"', add
label define hispand_lbl 490 `"Californio"', add
label define hispand_lbl 491 `"Tejano"', add
label define hispand_lbl 492 `"Nuevo Mexicano"', add
label define hispand_lbl 493 `"Spanish American"', add
label define hispand_lbl 494 `"Spanish American Indian"', add
label define hispand_lbl 495 `"Meso American Indian"', add
label define hispand_lbl 496 `"Mestizo"', add
label define hispand_lbl 498 `"Other, n.s."', add
label define hispand_lbl 499 `"Other, n.e.c."', add
label define hispand_lbl 900 `"Not Reported"', add
label values hispand hispand_lbl

label define school_lbl 0 `"N/A"'
label define school_lbl 1 `"No, not in school"', add
label define school_lbl 2 `"Yes, in school"', add
label define school_lbl 8 `"Unknown"', add
label define school_lbl 9 `"Missing"', add
label values school school_lbl

label define educ_lbl 00 `"N/A or no schooling"'
label define educ_lbl 01 `"Nursery school to grade 4"', add
label define educ_lbl 02 `"Grade 5, 6, 7, or 8"', add
label define educ_lbl 03 `"Grade 9"', add
label define educ_lbl 04 `"Grade 10"', add
label define educ_lbl 05 `"Grade 11"', add
label define educ_lbl 06 `"Grade 12"', add
label define educ_lbl 07 `"1 year of college"', add
label define educ_lbl 08 `"2 years of college"', add
label define educ_lbl 09 `"3 years of college"', add
label define educ_lbl 10 `"4 years of college"', add
label define educ_lbl 11 `"5+ years of college"', add
label define educ_lbl 99 `"Missing"', add
label values educ educ_lbl

label define educd_lbl 000 `"N/A or no schooling"'
label define educd_lbl 001 `"N/A"', add
label define educd_lbl 002 `"No schooling completed"', add
label define educd_lbl 010 `"Nursery school to grade 4"', add
label define educd_lbl 011 `"Nursery school, preschool"', add
label define educd_lbl 012 `"Kindergarten"', add
label define educd_lbl 013 `"Grade 1, 2, 3, or 4"', add
label define educd_lbl 014 `"Grade 1"', add
label define educd_lbl 015 `"Grade 2"', add
label define educd_lbl 016 `"Grade 3"', add
label define educd_lbl 017 `"Grade 4"', add
label define educd_lbl 020 `"Grade 5, 6, 7, or 8"', add
label define educd_lbl 021 `"Grade 5 or 6"', add
label define educd_lbl 022 `"Grade 5"', add
label define educd_lbl 023 `"Grade 6"', add
label define educd_lbl 024 `"Grade 7 or 8"', add
label define educd_lbl 025 `"Grade 7"', add
label define educd_lbl 026 `"Grade 8"', add
label define educd_lbl 030 `"Grade 9"', add
label define educd_lbl 040 `"Grade 10"', add
label define educd_lbl 050 `"Grade 11"', add
label define educd_lbl 060 `"Grade 12"', add
label define educd_lbl 061 `"12th grade, no diploma"', add
label define educd_lbl 062 `"High school graduate or GED"', add
label define educd_lbl 063 `"Regular high school diploma"', add
label define educd_lbl 064 `"GED or alternative credential"', add
label define educd_lbl 065 `"Some college, but less than 1 year"', add
label define educd_lbl 070 `"1 year of college"', add
label define educd_lbl 071 `"1 or more years of college credit, no degree"', add
label define educd_lbl 080 `"2 years of college"', add
label define educd_lbl 081 `"Associate's degree, type not specified"', add
label define educd_lbl 082 `"Associate's degree, occupational program"', add
label define educd_lbl 083 `"Associate's degree, academic program"', add
label define educd_lbl 090 `"3 years of college"', add
label define educd_lbl 100 `"4 years of college"', add
label define educd_lbl 101 `"Bachelor's degree"', add
label define educd_lbl 110 `"5+ years of college"', add
label define educd_lbl 111 `"6 years of college (6+ in 1960-1970)"', add
label define educd_lbl 112 `"7 years of college"', add
label define educd_lbl 113 `"8+ years of college"', add
label define educd_lbl 114 `"Master's degree"', add
label define educd_lbl 115 `"Professional degree beyond a bachelor's degree"', add
label define educd_lbl 116 `"Doctoral degree"', add
label define educd_lbl 999 `"Missing"', add
label values educd educd_lbl

label define degfield_lbl 00 `"N/A"'
label define degfield_lbl 11 `"Agriculture"', add
label define degfield_lbl 13 `"Environment and Natural Resources"', add
label define degfield_lbl 14 `"Architecture"', add
label define degfield_lbl 15 `"Area, Ethnic, and Civilization Studies"', add
label define degfield_lbl 19 `"Communications"', add
label define degfield_lbl 20 `"Communication Technologies"', add
label define degfield_lbl 21 `"Computer and Information Sciences"', add
label define degfield_lbl 22 `"Cosmetology Services and Culinary Arts"', add
label define degfield_lbl 23 `"Education Administration and Teaching"', add
label define degfield_lbl 24 `"Engineering"', add
label define degfield_lbl 25 `"Engineering Technologies"', add
label define degfield_lbl 26 `"Linguistics and Foreign Languages"', add
label define degfield_lbl 29 `"Family and Consumer Sciences"', add
label define degfield_lbl 32 `"Law"', add
label define degfield_lbl 33 `"English Language, Literature, and Composition"', add
label define degfield_lbl 34 `"Liberal Arts and Humanities"', add
label define degfield_lbl 35 `"Library Science"', add
label define degfield_lbl 36 `"Biology and Life Sciences"', add
label define degfield_lbl 37 `"Mathematics and Statistics"', add
label define degfield_lbl 38 `"Military Technologies"', add
label define degfield_lbl 40 `"Interdisciplinary and Multi-Disciplinary Studies (General)"', add
label define degfield_lbl 41 `"Physical Fitness, Parks, Recreation, and Leisure"', add
label define degfield_lbl 48 `"Philosophy and Religious Studies"', add
label define degfield_lbl 49 `"Theology and Religious Vocations"', add
label define degfield_lbl 50 `"Physical Sciences"', add
label define degfield_lbl 51 `"Nuclear, Industrial Radiology, and Biological Technologies"', add
label define degfield_lbl 52 `"Psychology"', add
label define degfield_lbl 53 `"Criminal Justice and Fire Protection"', add
label define degfield_lbl 54 `"Public Affairs, Policy, and Social Work"', add
label define degfield_lbl 55 `"Social Sciences"', add
label define degfield_lbl 56 `"Construction Services"', add
label define degfield_lbl 57 `"Electrical and Mechanic Repairs and Technologies"', add
label define degfield_lbl 58 `"Precision Production and Industrial Arts"', add
label define degfield_lbl 59 `"Transportation Sciences and Technologies"', add
label define degfield_lbl 60 `"Fine Arts"', add
label define degfield_lbl 61 `"Medical and Health Sciences and Services"', add
label define degfield_lbl 62 `"Business"', add
label define degfield_lbl 64 `"History"', add
label values degfield degfield_lbl

label define degfieldd_lbl 0000 `"N/A"'
label define degfieldd_lbl 1100 `"General Agriculture"', add
label define degfieldd_lbl 1101 `"Agriculture Production and Management"', add
label define degfieldd_lbl 1102 `"Agricultural Economics"', add
label define degfieldd_lbl 1103 `"Animal Sciences"', add
label define degfieldd_lbl 1104 `"Food Science"', add
label define degfieldd_lbl 1105 `"Plant Science and Agronomy"', add
label define degfieldd_lbl 1106 `"Soil Science"', add
label define degfieldd_lbl 1199 `"Miscellaneous Agriculture"', add
label define degfieldd_lbl 1300 `"Environment and Natural Resources"', add
label define degfieldd_lbl 1301 `"Environmental Science"', add
label define degfieldd_lbl 1302 `"Forestry"', add
label define degfieldd_lbl 1303 `"Natural Resources Management"', add
label define degfieldd_lbl 1401 `"Architecture"', add
label define degfieldd_lbl 1501 `"Area, Ethnic, and Civilization Studies"', add
label define degfieldd_lbl 1900 `"Communications"', add
label define degfieldd_lbl 1901 `"Communications"', add
label define degfieldd_lbl 1902 `"Journalism"', add
label define degfieldd_lbl 1903 `"Mass Media"', add
label define degfieldd_lbl 1904 `"Advertising and Public Relations"', add
label define degfieldd_lbl 2001 `"Communication Technologies"', add
label define degfieldd_lbl 2100 `"Computer and Information Systems"', add
label define degfieldd_lbl 2101 `"Computer Programming and Data Processing"', add
label define degfieldd_lbl 2102 `"Computer Science"', add
label define degfieldd_lbl 2105 `"Information Sciences"', add
label define degfieldd_lbl 2106 `"Computer Information Management and Security"', add
label define degfieldd_lbl 2107 `"Computer Networking and Telecommunications"', add
label define degfieldd_lbl 2201 `"Cosmetology Services and Culinary Arts"', add
label define degfieldd_lbl 2300 `"General Education"', add
label define degfieldd_lbl 2301 `"Educational Administration and Supervision"', add
label define degfieldd_lbl 2303 `"School Student Counseling"', add
label define degfieldd_lbl 2304 `"Elementary Education"', add
label define degfieldd_lbl 2305 `"Mathematics Teacher Education"', add
label define degfieldd_lbl 2306 `"Physical and Health Education Teaching"', add
label define degfieldd_lbl 2307 `"Early Childhood Education"', add
label define degfieldd_lbl 2308 `"Science  and Computer Teacher Education"', add
label define degfieldd_lbl 2309 `"Secondary Teacher Education"', add
label define degfieldd_lbl 2310 `"Special Needs Education"', add
label define degfieldd_lbl 2311 `"Social Science or History Teacher Education"', add
label define degfieldd_lbl 2312 `"Teacher Education:  Multiple Levels"', add
label define degfieldd_lbl 2313 `"Language and Drama Education"', add
label define degfieldd_lbl 2314 `"Art and Music Education"', add
label define degfieldd_lbl 2399 `"Miscellaneous Education"', add
label define degfieldd_lbl 2400 `"General Engineering"', add
label define degfieldd_lbl 2401 `"Aerospace Engineering"', add
label define degfieldd_lbl 2402 `"Biological Engineering"', add
label define degfieldd_lbl 2403 `"Architectural Engineering"', add
label define degfieldd_lbl 2404 `"Biomedical Engineering"', add
label define degfieldd_lbl 2405 `"Chemical Engineering"', add
label define degfieldd_lbl 2406 `"Civil Engineering"', add
label define degfieldd_lbl 2407 `"Computer Engineering"', add
label define degfieldd_lbl 2408 `"Electrical Engineering"', add
label define degfieldd_lbl 2409 `"Engineering Mechanics, Physics, and Science"', add
label define degfieldd_lbl 2410 `"Environmental Engineering"', add
label define degfieldd_lbl 2411 `"Geological and Geophysical Engineering"', add
label define degfieldd_lbl 2412 `"Industrial and Manufacturing Engineering"', add
label define degfieldd_lbl 2413 `"Materials Engineering and Materials Science"', add
label define degfieldd_lbl 2414 `"Mechanical Engineering"', add
label define degfieldd_lbl 2415 `"Metallurgical Engineering"', add
label define degfieldd_lbl 2416 `"Mining and Mineral Engineering"', add
label define degfieldd_lbl 2417 `"Naval Architecture and Marine Engineering"', add
label define degfieldd_lbl 2418 `"Nuclear Engineering"', add
label define degfieldd_lbl 2419 `"Petroleum Engineering"', add
label define degfieldd_lbl 2499 `"Miscellaneous Engineering"', add
label define degfieldd_lbl 2500 `"Engineering Technologies"', add
label define degfieldd_lbl 2501 `"Engineering and Industrial Management"', add
label define degfieldd_lbl 2502 `"Electrical Engineering Technology"', add
label define degfieldd_lbl 2503 `"Industrial Production Technologies"', add
label define degfieldd_lbl 2504 `"Mechanical Engineering Related Technologies"', add
label define degfieldd_lbl 2599 `"Miscellaneous Engineering Technologies"', add
label define degfieldd_lbl 2600 `"Linguistics and Foreign Languages"', add
label define degfieldd_lbl 2601 `"Linguistics and Comparative Language and Literature"', add
label define degfieldd_lbl 2602 `"French, German, Latin and Other Common Foreign Language Studies"', add
label define degfieldd_lbl 2603 `"Other Foreign Languages"', add
label define degfieldd_lbl 2901 `"Family and Consumer Sciences"', add
label define degfieldd_lbl 3200 `"Law"', add
label define degfieldd_lbl 3201 `"Court Reporting"', add
label define degfieldd_lbl 3202 `"Pre-Law and Legal Studies"', add
label define degfieldd_lbl 3300 `"English Language, Literature, and Composition"', add
label define degfieldd_lbl 3301 `"English Language and Literature"', add
label define degfieldd_lbl 3302 `"Composition and Speech"', add
label define degfieldd_lbl 3400 `"Liberal Arts and Humanities"', add
label define degfieldd_lbl 3401 `"Liberal Arts"', add
label define degfieldd_lbl 3402 `"Humanities"', add
label define degfieldd_lbl 3501 `"Library Science"', add
label define degfieldd_lbl 3600 `"Biology"', add
label define degfieldd_lbl 3601 `"Biochemical Sciences"', add
label define degfieldd_lbl 3602 `"Botany"', add
label define degfieldd_lbl 3603 `"Molecular Biology"', add
label define degfieldd_lbl 3604 `"Ecology"', add
label define degfieldd_lbl 3605 `"Genetics"', add
label define degfieldd_lbl 3606 `"Microbiology"', add
label define degfieldd_lbl 3607 `"Pharmacology"', add
label define degfieldd_lbl 3608 `"Physiology"', add
label define degfieldd_lbl 3609 `"Zoology"', add
label define degfieldd_lbl 3611 `"Neuroscience"', add
label define degfieldd_lbl 3699 `"Miscellaneous Biology"', add
label define degfieldd_lbl 3700 `"Mathematics"', add
label define degfieldd_lbl 3701 `"Applied Mathematics"', add
label define degfieldd_lbl 3702 `"Statistics and Decision Science"', add
label define degfieldd_lbl 3801 `"Military Technologies"', add
label define degfieldd_lbl 4000 `"Interdisciplinary and Multi-Disciplinary Studies (General)"', add
label define degfieldd_lbl 4001 `"Intercultural and International Studies"', add
label define degfieldd_lbl 4002 `"Nutrition Sciences"', add
label define degfieldd_lbl 4003 `"Neuroscience"', add
label define degfieldd_lbl 4005 `"Mathematics and Computer Science"', add
label define degfieldd_lbl 4006 `"Cognitive Science and Biopsychology"', add
label define degfieldd_lbl 4007 `"Interdisciplinary Social Sciences"', add
label define degfieldd_lbl 4008 `"Multi-disciplinary or General Science"', add
label define degfieldd_lbl 4101 `"Physical Fitness, Parks, Recreation, and Leisure"', add
label define degfieldd_lbl 4801 `"Philosophy and Religious Studies"', add
label define degfieldd_lbl 4901 `"Theology and Religious Vocations"', add
label define degfieldd_lbl 5000 `"Physical Sciences"', add
label define degfieldd_lbl 5001 `"Astronomy and Astrophysics"', add
label define degfieldd_lbl 5002 `"Atmospheric Sciences and Meteorology"', add
label define degfieldd_lbl 5003 `"Chemistry"', add
label define degfieldd_lbl 5004 `"Geology and Earth Science"', add
label define degfieldd_lbl 5005 `"Geosciences"', add
label define degfieldd_lbl 5006 `"Oceanography"', add
label define degfieldd_lbl 5007 `"Physics"', add
label define degfieldd_lbl 5008 `"Materials Science"', add
label define degfieldd_lbl 5098 `"Multi-disciplinary or General Science"', add
label define degfieldd_lbl 5102 `"Nuclear, Industrial Radiology, and Biological Technologies"', add
label define degfieldd_lbl 5200 `"Psychology"', add
label define degfieldd_lbl 5201 `"Educational Psychology"', add
label define degfieldd_lbl 5202 `"Clinical Psychology"', add
label define degfieldd_lbl 5203 `"Counseling Psychology"', add
label define degfieldd_lbl 5205 `"Industrial and Organizational Psychology"', add
label define degfieldd_lbl 5206 `"Social Psychology"', add
label define degfieldd_lbl 5299 `"Miscellaneous Psychology"', add
label define degfieldd_lbl 5301 `"Criminal Justice and Fire Protection"', add
label define degfieldd_lbl 5400 `"Public Affairs, Policy, and Social Work"', add
label define degfieldd_lbl 5401 `"Public Administration"', add
label define degfieldd_lbl 5402 `"Public Policy"', add
label define degfieldd_lbl 5403 `"Human Services and Community Organization"', add
label define degfieldd_lbl 5404 `"Social Work"', add
label define degfieldd_lbl 5500 `"General Social Sciences"', add
label define degfieldd_lbl 5501 `"Economics"', add
label define degfieldd_lbl 5502 `"Anthropology and Archeology"', add
label define degfieldd_lbl 5503 `"Criminology"', add
label define degfieldd_lbl 5504 `"Geography"', add
label define degfieldd_lbl 5505 `"International Relations"', add
label define degfieldd_lbl 5506 `"Political Science and Government"', add
label define degfieldd_lbl 5507 `"Sociology"', add
label define degfieldd_lbl 5599 `"Miscellaneous Social Sciences"', add
label define degfieldd_lbl 5601 `"Construction Services"', add
label define degfieldd_lbl 5701 `"Electrical and Mechanic Repairs and Technologies"', add
label define degfieldd_lbl 5801 `"Precision Production and Industrial Arts"', add
label define degfieldd_lbl 5901 `"Transportation Sciences and Technologies"', add
label define degfieldd_lbl 6000 `"Fine Arts"', add
label define degfieldd_lbl 6001 `"Drama and Theater Arts"', add
label define degfieldd_lbl 6002 `"Music"', add
label define degfieldd_lbl 6003 `"Visual and Performing Arts"', add
label define degfieldd_lbl 6004 `"Commercial Art and Graphic Design"', add
label define degfieldd_lbl 6005 `"Film, Video and Photographic Arts"', add
label define degfieldd_lbl 6006 `"Art History and Criticism"', add
label define degfieldd_lbl 6007 `"Studio Arts"', add
label define degfieldd_lbl 6099 `"Miscellaneous Fine Arts"', add
label define degfieldd_lbl 6100 `"General Medical and Health Services"', add
label define degfieldd_lbl 6102 `"Communication Disorders Sciences and Services"', add
label define degfieldd_lbl 6103 `"Health and Medical Administrative Services"', add
label define degfieldd_lbl 6104 `"Medical Assisting Services"', add
label define degfieldd_lbl 6105 `"Medical Technologies Technicians"', add
label define degfieldd_lbl 6106 `"Health and Medical Preparatory Programs"', add
label define degfieldd_lbl 6107 `"Nursing"', add
label define degfieldd_lbl 6108 `"Pharmacy, Pharmaceutical Sciences, and Administration"', add
label define degfieldd_lbl 6109 `"Treatment Therapy Professions"', add
label define degfieldd_lbl 6110 `"Community and Public Health"', add
label define degfieldd_lbl 6199 `"Miscellaneous Health Medical Professions"', add
label define degfieldd_lbl 6200 `"General Business"', add
label define degfieldd_lbl 6201 `"Accounting"', add
label define degfieldd_lbl 6202 `"Actuarial Science"', add
label define degfieldd_lbl 6203 `"Business Management and Administration"', add
label define degfieldd_lbl 6204 `"Operations, Logistics and E-Commerce"', add
label define degfieldd_lbl 6205 `"Business Economics"', add
label define degfieldd_lbl 6206 `"Marketing and Marketing Research"', add
label define degfieldd_lbl 6207 `"Finance"', add
label define degfieldd_lbl 6209 `"Human Resources and Personnel Management"', add
label define degfieldd_lbl 6210 `"International Business"', add
label define degfieldd_lbl 6211 `"Hospitality Management"', add
label define degfieldd_lbl 6212 `"Management Information Systems and Statistics"', add
label define degfieldd_lbl 6299 `"Miscellaneous Business and Medical Administration"', add
label define degfieldd_lbl 6402 `"History"', add
label define degfieldd_lbl 6403 `"United States History"', add
label values degfieldd degfieldd_lbl

label define empstat_lbl 0 `"N/A"'
label define empstat_lbl 1 `"Employed"', add
label define empstat_lbl 2 `"Unemployed"', add
label define empstat_lbl 3 `"Not in labor force"', add
label define empstat_lbl 9 `"Unknown/Illegible"', add
label values empstat empstat_lbl

label define empstatd_lbl 00 `"N/A"'
label define empstatd_lbl 10 `"At work"', add
label define empstatd_lbl 11 `"At work, public emerg"', add
label define empstatd_lbl 12 `"Has job, not working"', add
label define empstatd_lbl 13 `"Armed forces"', add
label define empstatd_lbl 14 `"Armed forces--at work"', add
label define empstatd_lbl 15 `"Armed forces--not at work but with job"', add
label define empstatd_lbl 20 `"Unemployed"', add
label define empstatd_lbl 21 `"Unemp, exper worker"', add
label define empstatd_lbl 22 `"Unemp, new worker"', add
label define empstatd_lbl 30 `"Not in Labor Force"', add
label define empstatd_lbl 31 `"NILF, housework"', add
label define empstatd_lbl 32 `"NILF, unable to work"', add
label define empstatd_lbl 33 `"NILF, school"', add
label define empstatd_lbl 34 `"NILF, other"', add
label define empstatd_lbl 99 `"Unknown/Illegible"', add
label values empstatd empstatd_lbl

label define labforce_lbl 0 `"N/A"'
label define labforce_lbl 1 `"No, not in the labor force"', add
label define labforce_lbl 2 `"Yes, in the labor force"', add
label define labforce_lbl 9 `"Unclassifiable (employment status unknown)"', add
label values labforce labforce_lbl

label define occ_lbl 0000 `"0000"'
label define occ_lbl 0001 `"0001"', add
label define occ_lbl 0002 `"0002"', add
label define occ_lbl 0003 `"0003"', add
label define occ_lbl 0004 `"0004"', add
label define occ_lbl 0005 `"0005"', add
label define occ_lbl 0006 `"0006"', add
label define occ_lbl 0007 `"0007"', add
label define occ_lbl 0008 `"0008"', add
label define occ_lbl 0009 `"0009"', add
label define occ_lbl 0010 `"0010"', add
label define occ_lbl 0011 `"0011"', add
label define occ_lbl 0012 `"0012"', add
label define occ_lbl 0013 `"0013"', add
label define occ_lbl 0014 `"0014"', add
label define occ_lbl 0015 `"0015"', add
label define occ_lbl 0016 `"0016"', add
label define occ_lbl 0017 `"0017"', add
label define occ_lbl 0018 `"0018"', add
label define occ_lbl 0019 `"0019"', add
label define occ_lbl 0020 `"0020"', add
label define occ_lbl 0021 `"0021"', add
label define occ_lbl 0022 `"0022"', add
label define occ_lbl 0023 `"0023"', add
label define occ_lbl 0024 `"0024"', add
label define occ_lbl 0025 `"0025"', add
label define occ_lbl 0026 `"0026"', add
label define occ_lbl 0027 `"0027"', add
label define occ_lbl 0028 `"0028"', add
label define occ_lbl 0029 `"0029"', add
label define occ_lbl 0030 `"0030"', add
label define occ_lbl 0031 `"0031"', add
label define occ_lbl 0032 `"0032"', add
label define occ_lbl 0033 `"0033"', add
label define occ_lbl 0034 `"0034"', add
label define occ_lbl 0035 `"0035"', add
label define occ_lbl 0036 `"0036"', add
label define occ_lbl 0037 `"0037"', add
label define occ_lbl 0038 `"0038"', add
label define occ_lbl 0039 `"0039"', add
label define occ_lbl 0040 `"0040"', add
label define occ_lbl 0041 `"0041"', add
label define occ_lbl 0042 `"0042"', add
label define occ_lbl 0043 `"0043"', add
label define occ_lbl 0044 `"0044"', add
label define occ_lbl 0045 `"0045"', add
label define occ_lbl 0046 `"0046"', add
label define occ_lbl 0047 `"0047"', add
label define occ_lbl 0048 `"0048"', add
label define occ_lbl 0049 `"0049"', add
label define occ_lbl 0050 `"0050"', add
label define occ_lbl 0051 `"0051"', add
label define occ_lbl 0052 `"0052"', add
label define occ_lbl 0053 `"0053"', add
label define occ_lbl 0054 `"0054"', add
label define occ_lbl 0055 `"0055"', add
label define occ_lbl 0056 `"0056"', add
label define occ_lbl 0057 `"0057"', add
label define occ_lbl 0058 `"0058"', add
label define occ_lbl 0059 `"0059"', add
label define occ_lbl 0060 `"0060"', add
label define occ_lbl 0061 `"0061"', add
label define occ_lbl 0062 `"0062"', add
label define occ_lbl 0063 `"0063"', add
label define occ_lbl 0064 `"0064"', add
label define occ_lbl 0065 `"0065"', add
label define occ_lbl 0066 `"0066"', add
label define occ_lbl 0067 `"0067"', add
label define occ_lbl 0068 `"0068"', add
label define occ_lbl 0069 `"0069"', add
label define occ_lbl 0070 `"0070"', add
label define occ_lbl 0071 `"0071"', add
label define occ_lbl 0072 `"0072"', add
label define occ_lbl 0073 `"0073"', add
label define occ_lbl 0074 `"0074"', add
label define occ_lbl 0075 `"0075"', add
label define occ_lbl 0076 `"0076"', add
label define occ_lbl 0077 `"0077"', add
label define occ_lbl 0078 `"0078"', add
label define occ_lbl 0079 `"0079"', add
label define occ_lbl 0080 `"0080"', add
label define occ_lbl 0081 `"0081"', add
label define occ_lbl 0082 `"0082"', add
label define occ_lbl 0083 `"0083"', add
label define occ_lbl 0084 `"0084"', add
label define occ_lbl 0085 `"0085"', add
label define occ_lbl 0086 `"0086"', add
label define occ_lbl 0087 `"0087"', add
label define occ_lbl 0088 `"0088"', add
label define occ_lbl 0089 `"0089"', add
label define occ_lbl 0090 `"0090"', add
label define occ_lbl 0091 `"0091"', add
label define occ_lbl 0092 `"0092"', add
label define occ_lbl 0093 `"0093"', add
label define occ_lbl 0094 `"0094"', add
label define occ_lbl 0095 `"0095"', add
label define occ_lbl 0096 `"0096"', add
label define occ_lbl 0097 `"0097"', add
label define occ_lbl 0098 `"0098"', add
label define occ_lbl 0099 `"0099"', add
label define occ_lbl 0100 `"0100"', add
label define occ_lbl 0101 `"0101"', add
label define occ_lbl 0102 `"0102"', add
label define occ_lbl 0103 `"0103"', add
label define occ_lbl 0104 `"0104"', add
label define occ_lbl 0105 `"0105"', add
label define occ_lbl 0106 `"0106"', add
label define occ_lbl 0107 `"0107"', add
label define occ_lbl 0108 `"0108"', add
label define occ_lbl 0109 `"0109"', add
label define occ_lbl 0110 `"0110"', add
label define occ_lbl 0111 `"0111"', add
label define occ_lbl 0112 `"0112"', add
label define occ_lbl 0113 `"0113"', add
label define occ_lbl 0114 `"0114"', add
label define occ_lbl 0115 `"0115"', add
label define occ_lbl 0116 `"0116"', add
label define occ_lbl 0117 `"0117"', add
label define occ_lbl 0118 `"0118"', add
label define occ_lbl 0119 `"0119"', add
label define occ_lbl 0120 `"0120"', add
label define occ_lbl 0121 `"0121"', add
label define occ_lbl 0122 `"0122"', add
label define occ_lbl 0123 `"0123"', add
label define occ_lbl 0124 `"0124"', add
label define occ_lbl 0125 `"0125"', add
label define occ_lbl 0126 `"0126"', add
label define occ_lbl 0127 `"0127"', add
label define occ_lbl 0128 `"0128"', add
label define occ_lbl 0129 `"0129"', add
label define occ_lbl 0130 `"0130"', add
label define occ_lbl 0131 `"0131"', add
label define occ_lbl 0132 `"0132"', add
label define occ_lbl 0133 `"0133"', add
label define occ_lbl 0134 `"0134"', add
label define occ_lbl 0135 `"0135"', add
label define occ_lbl 0136 `"0136"', add
label define occ_lbl 0137 `"0137"', add
label define occ_lbl 0138 `"0138"', add
label define occ_lbl 0139 `"0139"', add
label define occ_lbl 0140 `"0140"', add
label define occ_lbl 0141 `"0141"', add
label define occ_lbl 0142 `"0142"', add
label define occ_lbl 0143 `"0143"', add
label define occ_lbl 0144 `"0144"', add
label define occ_lbl 0145 `"0145"', add
label define occ_lbl 0146 `"0146"', add
label define occ_lbl 0147 `"0147"', add
label define occ_lbl 0148 `"0148"', add
label define occ_lbl 0149 `"0149"', add
label define occ_lbl 0150 `"0150"', add
label define occ_lbl 0151 `"0151"', add
label define occ_lbl 0152 `"0152"', add
label define occ_lbl 0153 `"0153"', add
label define occ_lbl 0154 `"0154"', add
label define occ_lbl 0155 `"0155"', add
label define occ_lbl 0156 `"0156"', add
label define occ_lbl 0157 `"0157"', add
label define occ_lbl 0158 `"0158"', add
label define occ_lbl 0159 `"0159"', add
label define occ_lbl 0160 `"0160"', add
label define occ_lbl 0161 `"0161"', add
label define occ_lbl 0162 `"0162"', add
label define occ_lbl 0163 `"0163"', add
label define occ_lbl 0164 `"0164"', add
label define occ_lbl 0165 `"0165"', add
label define occ_lbl 0166 `"0166"', add
label define occ_lbl 0167 `"0167"', add
label define occ_lbl 0168 `"0168"', add
label define occ_lbl 0169 `"0169"', add
label define occ_lbl 0170 `"0170"', add
label define occ_lbl 0171 `"0171"', add
label define occ_lbl 0172 `"0172"', add
label define occ_lbl 0173 `"0173"', add
label define occ_lbl 0174 `"0174"', add
label define occ_lbl 0175 `"0175"', add
label define occ_lbl 0176 `"0176"', add
label define occ_lbl 0177 `"0177"', add
label define occ_lbl 0178 `"0178"', add
label define occ_lbl 0179 `"0179"', add
label define occ_lbl 0180 `"0180"', add
label define occ_lbl 0181 `"0181"', add
label define occ_lbl 0182 `"0182"', add
label define occ_lbl 0183 `"0183"', add
label define occ_lbl 0184 `"0184"', add
label define occ_lbl 0185 `"0185"', add
label define occ_lbl 0186 `"0186"', add
label define occ_lbl 0187 `"0187"', add
label define occ_lbl 0188 `"0188"', add
label define occ_lbl 0189 `"0189"', add
label define occ_lbl 0190 `"0190"', add
label define occ_lbl 0191 `"0191"', add
label define occ_lbl 0192 `"0192"', add
label define occ_lbl 0193 `"0193"', add
label define occ_lbl 0194 `"0194"', add
label define occ_lbl 0195 `"0195"', add
label define occ_lbl 0196 `"0196"', add
label define occ_lbl 0197 `"0197"', add
label define occ_lbl 0198 `"0198"', add
label define occ_lbl 0199 `"0199"', add
label define occ_lbl 0200 `"0200"', add
label define occ_lbl 0201 `"0201"', add
label define occ_lbl 0202 `"0202"', add
label define occ_lbl 0203 `"0203"', add
label define occ_lbl 0204 `"0204"', add
label define occ_lbl 0205 `"0205"', add
label define occ_lbl 0206 `"0206"', add
label define occ_lbl 0207 `"0207"', add
label define occ_lbl 0208 `"0208"', add
label define occ_lbl 0209 `"0209"', add
label define occ_lbl 0210 `"0210"', add
label define occ_lbl 0211 `"0211"', add
label define occ_lbl 0212 `"0212"', add
label define occ_lbl 0213 `"0213"', add
label define occ_lbl 0214 `"0214"', add
label define occ_lbl 0215 `"0215"', add
label define occ_lbl 0216 `"0216"', add
label define occ_lbl 0217 `"0217"', add
label define occ_lbl 0218 `"0218"', add
label define occ_lbl 0219 `"0219"', add
label define occ_lbl 0220 `"0220"', add
label define occ_lbl 0221 `"0221"', add
label define occ_lbl 0222 `"0222"', add
label define occ_lbl 0223 `"0223"', add
label define occ_lbl 0224 `"0224"', add
label define occ_lbl 0225 `"0225"', add
label define occ_lbl 0226 `"0226"', add
label define occ_lbl 0227 `"0227"', add
label define occ_lbl 0228 `"0228"', add
label define occ_lbl 0229 `"0229"', add
label define occ_lbl 0230 `"0230"', add
label define occ_lbl 0231 `"0231"', add
label define occ_lbl 0232 `"0232"', add
label define occ_lbl 0233 `"0233"', add
label define occ_lbl 0234 `"0234"', add
label define occ_lbl 0235 `"0235"', add
label define occ_lbl 0236 `"0236"', add
label define occ_lbl 0237 `"0237"', add
label define occ_lbl 0238 `"0238"', add
label define occ_lbl 0239 `"0239"', add
label define occ_lbl 0240 `"0240"', add
label define occ_lbl 0241 `"0241"', add
label define occ_lbl 0242 `"0242"', add
label define occ_lbl 0243 `"0243"', add
label define occ_lbl 0244 `"0244"', add
label define occ_lbl 0245 `"0245"', add
label define occ_lbl 0246 `"0246"', add
label define occ_lbl 0247 `"0247"', add
label define occ_lbl 0248 `"0248"', add
label define occ_lbl 0249 `"0249"', add
label define occ_lbl 0250 `"0250"', add
label define occ_lbl 0251 `"0251"', add
label define occ_lbl 0252 `"0252"', add
label define occ_lbl 0253 `"0253"', add
label define occ_lbl 0254 `"0254"', add
label define occ_lbl 0255 `"0255"', add
label define occ_lbl 0256 `"0256"', add
label define occ_lbl 0257 `"0257"', add
label define occ_lbl 0258 `"0258"', add
label define occ_lbl 0259 `"0259"', add
label define occ_lbl 0260 `"0260"', add
label define occ_lbl 0261 `"0261"', add
label define occ_lbl 0262 `"0262"', add
label define occ_lbl 0263 `"0263"', add
label define occ_lbl 0264 `"0264"', add
label define occ_lbl 0265 `"0265"', add
label define occ_lbl 0266 `"0266"', add
label define occ_lbl 0267 `"0267"', add
label define occ_lbl 0268 `"0268"', add
label define occ_lbl 0269 `"0269"', add
label define occ_lbl 0270 `"0270"', add
label define occ_lbl 0271 `"0271"', add
label define occ_lbl 0272 `"0272"', add
label define occ_lbl 0273 `"0273"', add
label define occ_lbl 0274 `"0274"', add
label define occ_lbl 0275 `"0275"', add
label define occ_lbl 0276 `"0276"', add
label define occ_lbl 0277 `"0277"', add
label define occ_lbl 0278 `"0278"', add
label define occ_lbl 0279 `"0279"', add
label define occ_lbl 0280 `"0280"', add
label define occ_lbl 0281 `"0281"', add
label define occ_lbl 0282 `"0282"', add
label define occ_lbl 0283 `"0283"', add
label define occ_lbl 0284 `"0284"', add
label define occ_lbl 0285 `"0285"', add
label define occ_lbl 0286 `"0286"', add
label define occ_lbl 0287 `"0287"', add
label define occ_lbl 0288 `"0288"', add
label define occ_lbl 0289 `"0289"', add
label define occ_lbl 0290 `"0290"', add
label define occ_lbl 0291 `"0291"', add
label define occ_lbl 0292 `"0292"', add
label define occ_lbl 0293 `"0293"', add
label define occ_lbl 0294 `"0294"', add
label define occ_lbl 0295 `"0295"', add
label define occ_lbl 0296 `"0296"', add
label define occ_lbl 0297 `"0297"', add
label define occ_lbl 0298 `"0298"', add
label define occ_lbl 0299 `"0299"', add
label define occ_lbl 0300 `"0300"', add
label define occ_lbl 0301 `"0301"', add
label define occ_lbl 0302 `"0302"', add
label define occ_lbl 0303 `"0303"', add
label define occ_lbl 0304 `"0304"', add
label define occ_lbl 0305 `"0305"', add
label define occ_lbl 0306 `"0306"', add
label define occ_lbl 0307 `"0307"', add
label define occ_lbl 0308 `"0308"', add
label define occ_lbl 0309 `"0309"', add
label define occ_lbl 0310 `"0310"', add
label define occ_lbl 0311 `"0311"', add
label define occ_lbl 0312 `"0312"', add
label define occ_lbl 0313 `"0313"', add
label define occ_lbl 0314 `"0314"', add
label define occ_lbl 0315 `"0315"', add
label define occ_lbl 0316 `"0316"', add
label define occ_lbl 0317 `"0317"', add
label define occ_lbl 0318 `"0318"', add
label define occ_lbl 0319 `"0319"', add
label define occ_lbl 0320 `"0320"', add
label define occ_lbl 0321 `"0321"', add
label define occ_lbl 0322 `"0322"', add
label define occ_lbl 0323 `"0323"', add
label define occ_lbl 0324 `"0324"', add
label define occ_lbl 0325 `"0325"', add
label define occ_lbl 0326 `"0326"', add
label define occ_lbl 0327 `"0327"', add
label define occ_lbl 0328 `"0328"', add
label define occ_lbl 0329 `"0329"', add
label define occ_lbl 0330 `"0330"', add
label define occ_lbl 0331 `"0331"', add
label define occ_lbl 0332 `"0332"', add
label define occ_lbl 0333 `"0333"', add
label define occ_lbl 0334 `"0334"', add
label define occ_lbl 0335 `"0335"', add
label define occ_lbl 0336 `"0336"', add
label define occ_lbl 0337 `"0337"', add
label define occ_lbl 0338 `"0338"', add
label define occ_lbl 0339 `"0339"', add
label define occ_lbl 0340 `"0340"', add
label define occ_lbl 0341 `"0341"', add
label define occ_lbl 0342 `"0342"', add
label define occ_lbl 0343 `"0343"', add
label define occ_lbl 0344 `"0344"', add
label define occ_lbl 0345 `"0345"', add
label define occ_lbl 0346 `"0346"', add
label define occ_lbl 0347 `"0347"', add
label define occ_lbl 0348 `"0348"', add
label define occ_lbl 0349 `"0349"', add
label define occ_lbl 0350 `"0350"', add
label define occ_lbl 0351 `"0351"', add
label define occ_lbl 0352 `"0352"', add
label define occ_lbl 0353 `"0353"', add
label define occ_lbl 0354 `"0354"', add
label define occ_lbl 0355 `"0355"', add
label define occ_lbl 0356 `"0356"', add
label define occ_lbl 0357 `"0357"', add
label define occ_lbl 0358 `"0358"', add
label define occ_lbl 0359 `"0359"', add
label define occ_lbl 0360 `"0360"', add
label define occ_lbl 0361 `"0361"', add
label define occ_lbl 0362 `"0362"', add
label define occ_lbl 0363 `"0363"', add
label define occ_lbl 0364 `"0364"', add
label define occ_lbl 0365 `"0365"', add
label define occ_lbl 0366 `"0366"', add
label define occ_lbl 0367 `"0367"', add
label define occ_lbl 0368 `"0368"', add
label define occ_lbl 0369 `"0369"', add
label define occ_lbl 0370 `"0370"', add
label define occ_lbl 0371 `"0371"', add
label define occ_lbl 0372 `"0372"', add
label define occ_lbl 0373 `"0373"', add
label define occ_lbl 0374 `"0374"', add
label define occ_lbl 0375 `"0375"', add
label define occ_lbl 0376 `"0376"', add
label define occ_lbl 0377 `"0377"', add
label define occ_lbl 0378 `"0378"', add
label define occ_lbl 0379 `"0379"', add
label define occ_lbl 0380 `"0380"', add
label define occ_lbl 0381 `"0381"', add
label define occ_lbl 0382 `"0382"', add
label define occ_lbl 0383 `"0383"', add
label define occ_lbl 0384 `"0384"', add
label define occ_lbl 0385 `"0385"', add
label define occ_lbl 0386 `"0386"', add
label define occ_lbl 0387 `"0387"', add
label define occ_lbl 0388 `"0388"', add
label define occ_lbl 0389 `"0389"', add
label define occ_lbl 0390 `"0390"', add
label define occ_lbl 0391 `"0391"', add
label define occ_lbl 0392 `"0392"', add
label define occ_lbl 0393 `"0393"', add
label define occ_lbl 0394 `"0394"', add
label define occ_lbl 0395 `"0395"', add
label define occ_lbl 0396 `"0396"', add
label define occ_lbl 0397 `"0397"', add
label define occ_lbl 0398 `"0398"', add
label define occ_lbl 0399 `"0399"', add
label define occ_lbl 0400 `"0400"', add
label define occ_lbl 0401 `"0401"', add
label define occ_lbl 0402 `"0402"', add
label define occ_lbl 0403 `"0403"', add
label define occ_lbl 0404 `"0404"', add
label define occ_lbl 0405 `"0405"', add
label define occ_lbl 0406 `"0406"', add
label define occ_lbl 0407 `"0407"', add
label define occ_lbl 0408 `"0408"', add
label define occ_lbl 0409 `"0409"', add
label define occ_lbl 0410 `"0410"', add
label define occ_lbl 0411 `"0411"', add
label define occ_lbl 0412 `"0412"', add
label define occ_lbl 0413 `"0413"', add
label define occ_lbl 0414 `"0414"', add
label define occ_lbl 0415 `"0415"', add
label define occ_lbl 0416 `"0416"', add
label define occ_lbl 0417 `"0417"', add
label define occ_lbl 0418 `"0418"', add
label define occ_lbl 0419 `"0419"', add
label define occ_lbl 0420 `"0420"', add
label define occ_lbl 0421 `"0421"', add
label define occ_lbl 0422 `"0422"', add
label define occ_lbl 0423 `"0423"', add
label define occ_lbl 0424 `"0424"', add
label define occ_lbl 0425 `"0425"', add
label define occ_lbl 0426 `"0426"', add
label define occ_lbl 0427 `"0427"', add
label define occ_lbl 0428 `"0428"', add
label define occ_lbl 0429 `"0429"', add
label define occ_lbl 0430 `"0430"', add
label define occ_lbl 0431 `"0431"', add
label define occ_lbl 0432 `"0432"', add
label define occ_lbl 0433 `"0433"', add
label define occ_lbl 0434 `"0434"', add
label define occ_lbl 0435 `"0435"', add
label define occ_lbl 0436 `"0436"', add
label define occ_lbl 0437 `"0437"', add
label define occ_lbl 0438 `"0438"', add
label define occ_lbl 0439 `"0439"', add
label define occ_lbl 0440 `"0440"', add
label define occ_lbl 0441 `"0441"', add
label define occ_lbl 0442 `"0442"', add
label define occ_lbl 0443 `"0443"', add
label define occ_lbl 0444 `"0444"', add
label define occ_lbl 0445 `"0445"', add
label define occ_lbl 0446 `"0446"', add
label define occ_lbl 0447 `"0447"', add
label define occ_lbl 0448 `"0448"', add
label define occ_lbl 0449 `"0449"', add
label define occ_lbl 0450 `"0450"', add
label define occ_lbl 0451 `"0451"', add
label define occ_lbl 0452 `"0452"', add
label define occ_lbl 0453 `"0453"', add
label define occ_lbl 0454 `"0454"', add
label define occ_lbl 0455 `"0455"', add
label define occ_lbl 0456 `"0456"', add
label define occ_lbl 0457 `"0457"', add
label define occ_lbl 0458 `"0458"', add
label define occ_lbl 0459 `"0459"', add
label define occ_lbl 0460 `"0460"', add
label define occ_lbl 0461 `"0461"', add
label define occ_lbl 0462 `"0462"', add
label define occ_lbl 0463 `"0463"', add
label define occ_lbl 0464 `"0464"', add
label define occ_lbl 0465 `"0465"', add
label define occ_lbl 0466 `"0466"', add
label define occ_lbl 0467 `"0467"', add
label define occ_lbl 0468 `"0468"', add
label define occ_lbl 0469 `"0469"', add
label define occ_lbl 0470 `"0470"', add
label define occ_lbl 0471 `"0471"', add
label define occ_lbl 0472 `"0472"', add
label define occ_lbl 0473 `"0473"', add
label define occ_lbl 0474 `"0474"', add
label define occ_lbl 0475 `"0475"', add
label define occ_lbl 0476 `"0476"', add
label define occ_lbl 0477 `"0477"', add
label define occ_lbl 0478 `"0478"', add
label define occ_lbl 0479 `"0479"', add
label define occ_lbl 0480 `"0480"', add
label define occ_lbl 0481 `"0481"', add
label define occ_lbl 0482 `"0482"', add
label define occ_lbl 0483 `"0483"', add
label define occ_lbl 0484 `"0484"', add
label define occ_lbl 0485 `"0485"', add
label define occ_lbl 0486 `"0486"', add
label define occ_lbl 0487 `"0487"', add
label define occ_lbl 0488 `"0488"', add
label define occ_lbl 0489 `"0489"', add
label define occ_lbl 0490 `"0490"', add
label define occ_lbl 0491 `"0491"', add
label define occ_lbl 0492 `"0492"', add
label define occ_lbl 0493 `"0493"', add
label define occ_lbl 0494 `"0494"', add
label define occ_lbl 0495 `"0495"', add
label define occ_lbl 0496 `"0496"', add
label define occ_lbl 0497 `"0497"', add
label define occ_lbl 0498 `"0498"', add
label define occ_lbl 0499 `"0499"', add
label define occ_lbl 0500 `"0500"', add
label define occ_lbl 0501 `"0501"', add
label define occ_lbl 0502 `"0502"', add
label define occ_lbl 0503 `"0503"', add
label define occ_lbl 0504 `"0504"', add
label define occ_lbl 0505 `"0505"', add
label define occ_lbl 0506 `"0506"', add
label define occ_lbl 0507 `"0507"', add
label define occ_lbl 0508 `"0508"', add
label define occ_lbl 0509 `"0509"', add
label define occ_lbl 0510 `"0510"', add
label define occ_lbl 0511 `"0511"', add
label define occ_lbl 0512 `"0512"', add
label define occ_lbl 0513 `"0513"', add
label define occ_lbl 0514 `"0514"', add
label define occ_lbl 0515 `"0515"', add
label define occ_lbl 0516 `"0516"', add
label define occ_lbl 0517 `"0517"', add
label define occ_lbl 0518 `"0518"', add
label define occ_lbl 0519 `"0519"', add
label define occ_lbl 0520 `"0520"', add
label define occ_lbl 0521 `"0521"', add
label define occ_lbl 0522 `"0522"', add
label define occ_lbl 0523 `"0523"', add
label define occ_lbl 0524 `"0524"', add
label define occ_lbl 0525 `"0525"', add
label define occ_lbl 0526 `"0526"', add
label define occ_lbl 0527 `"0527"', add
label define occ_lbl 0528 `"0528"', add
label define occ_lbl 0529 `"0529"', add
label define occ_lbl 0530 `"0530"', add
label define occ_lbl 0531 `"0531"', add
label define occ_lbl 0532 `"0532"', add
label define occ_lbl 0533 `"0533"', add
label define occ_lbl 0534 `"0534"', add
label define occ_lbl 0535 `"0535"', add
label define occ_lbl 0536 `"0536"', add
label define occ_lbl 0537 `"0537"', add
label define occ_lbl 0538 `"0538"', add
label define occ_lbl 0539 `"0539"', add
label define occ_lbl 0540 `"0540"', add
label define occ_lbl 0541 `"0541"', add
label define occ_lbl 0542 `"0542"', add
label define occ_lbl 0543 `"0543"', add
label define occ_lbl 0544 `"0544"', add
label define occ_lbl 0545 `"0545"', add
label define occ_lbl 0546 `"0546"', add
label define occ_lbl 0547 `"0547"', add
label define occ_lbl 0548 `"0548"', add
label define occ_lbl 0549 `"0549"', add
label define occ_lbl 0550 `"0550"', add
label define occ_lbl 0551 `"0551"', add
label define occ_lbl 0552 `"0552"', add
label define occ_lbl 0553 `"0553"', add
label define occ_lbl 0554 `"0554"', add
label define occ_lbl 0555 `"0555"', add
label define occ_lbl 0556 `"0556"', add
label define occ_lbl 0557 `"0557"', add
label define occ_lbl 0558 `"0558"', add
label define occ_lbl 0559 `"0559"', add
label define occ_lbl 0560 `"0560"', add
label define occ_lbl 0561 `"0561"', add
label define occ_lbl 0562 `"0562"', add
label define occ_lbl 0563 `"0563"', add
label define occ_lbl 0564 `"0564"', add
label define occ_lbl 0565 `"0565"', add
label define occ_lbl 0566 `"0566"', add
label define occ_lbl 0567 `"0567"', add
label define occ_lbl 0568 `"0568"', add
label define occ_lbl 0569 `"0569"', add
label define occ_lbl 0570 `"0570"', add
label define occ_lbl 0571 `"0571"', add
label define occ_lbl 0572 `"0572"', add
label define occ_lbl 0573 `"0573"', add
label define occ_lbl 0574 `"0574"', add
label define occ_lbl 0575 `"0575"', add
label define occ_lbl 0576 `"0576"', add
label define occ_lbl 0577 `"0577"', add
label define occ_lbl 0578 `"0578"', add
label define occ_lbl 0579 `"0579"', add
label define occ_lbl 0580 `"0580"', add
label define occ_lbl 0581 `"0581"', add
label define occ_lbl 0582 `"0582"', add
label define occ_lbl 0583 `"0583"', add
label define occ_lbl 0584 `"0584"', add
label define occ_lbl 0585 `"0585"', add
label define occ_lbl 0586 `"0586"', add
label define occ_lbl 0587 `"0587"', add
label define occ_lbl 0588 `"0588"', add
label define occ_lbl 0589 `"0589"', add
label define occ_lbl 0590 `"0590"', add
label define occ_lbl 0591 `"0591"', add
label define occ_lbl 0592 `"0592"', add
label define occ_lbl 0593 `"0593"', add
label define occ_lbl 0594 `"0594"', add
label define occ_lbl 0595 `"0595"', add
label define occ_lbl 0596 `"0596"', add
label define occ_lbl 0597 `"0597"', add
label define occ_lbl 0598 `"0598"', add
label define occ_lbl 0599 `"0599"', add
label define occ_lbl 0600 `"0600"', add
label define occ_lbl 0601 `"0601"', add
label define occ_lbl 0602 `"0602"', add
label define occ_lbl 0603 `"0603"', add
label define occ_lbl 0604 `"0604"', add
label define occ_lbl 0605 `"0605"', add
label define occ_lbl 0606 `"0606"', add
label define occ_lbl 0607 `"0607"', add
label define occ_lbl 0608 `"0608"', add
label define occ_lbl 0609 `"0609"', add
label define occ_lbl 0610 `"0610"', add
label define occ_lbl 0611 `"0611"', add
label define occ_lbl 0612 `"0612"', add
label define occ_lbl 0613 `"0613"', add
label define occ_lbl 0614 `"0614"', add
label define occ_lbl 0615 `"0615"', add
label define occ_lbl 0616 `"0616"', add
label define occ_lbl 0617 `"0617"', add
label define occ_lbl 0618 `"0618"', add
label define occ_lbl 0619 `"0619"', add
label define occ_lbl 0620 `"0620"', add
label define occ_lbl 0621 `"0621"', add
label define occ_lbl 0622 `"0622"', add
label define occ_lbl 0623 `"0623"', add
label define occ_lbl 0624 `"0624"', add
label define occ_lbl 0625 `"0625"', add
label define occ_lbl 0626 `"0626"', add
label define occ_lbl 0627 `"0627"', add
label define occ_lbl 0628 `"0628"', add
label define occ_lbl 0629 `"0629"', add
label define occ_lbl 0630 `"0630"', add
label define occ_lbl 0631 `"0631"', add
label define occ_lbl 0632 `"0632"', add
label define occ_lbl 0633 `"0633"', add
label define occ_lbl 0634 `"0634"', add
label define occ_lbl 0635 `"0635"', add
label define occ_lbl 0636 `"0636"', add
label define occ_lbl 0637 `"0637"', add
label define occ_lbl 0638 `"0638"', add
label define occ_lbl 0639 `"0639"', add
label define occ_lbl 0640 `"0640"', add
label define occ_lbl 0641 `"0641"', add
label define occ_lbl 0642 `"0642"', add
label define occ_lbl 0643 `"0643"', add
label define occ_lbl 0644 `"0644"', add
label define occ_lbl 0645 `"0645"', add
label define occ_lbl 0646 `"0646"', add
label define occ_lbl 0647 `"0647"', add
label define occ_lbl 0648 `"0648"', add
label define occ_lbl 0649 `"0649"', add
label define occ_lbl 0650 `"0650"', add
label define occ_lbl 0651 `"0651"', add
label define occ_lbl 0652 `"0652"', add
label define occ_lbl 0653 `"0653"', add
label define occ_lbl 0654 `"0654"', add
label define occ_lbl 0655 `"0655"', add
label define occ_lbl 0656 `"0656"', add
label define occ_lbl 0657 `"0657"', add
label define occ_lbl 0658 `"0658"', add
label define occ_lbl 0659 `"0659"', add
label define occ_lbl 0660 `"0660"', add
label define occ_lbl 0661 `"0661"', add
label define occ_lbl 0662 `"0662"', add
label define occ_lbl 0663 `"0663"', add
label define occ_lbl 0664 `"0664"', add
label define occ_lbl 0665 `"0665"', add
label define occ_lbl 0666 `"0666"', add
label define occ_lbl 0667 `"0667"', add
label define occ_lbl 0668 `"0668"', add
label define occ_lbl 0669 `"0669"', add
label define occ_lbl 0670 `"0670"', add
label define occ_lbl 0671 `"0671"', add
label define occ_lbl 0672 `"0672"', add
label define occ_lbl 0673 `"0673"', add
label define occ_lbl 0674 `"0674"', add
label define occ_lbl 0675 `"0675"', add
label define occ_lbl 0676 `"0676"', add
label define occ_lbl 0677 `"0677"', add
label define occ_lbl 0678 `"0678"', add
label define occ_lbl 0679 `"0679"', add
label define occ_lbl 0680 `"0680"', add
label define occ_lbl 0681 `"0681"', add
label define occ_lbl 0682 `"0682"', add
label define occ_lbl 0683 `"0683"', add
label define occ_lbl 0684 `"0684"', add
label define occ_lbl 0685 `"0685"', add
label define occ_lbl 0686 `"0686"', add
label define occ_lbl 0687 `"0687"', add
label define occ_lbl 0688 `"0688"', add
label define occ_lbl 0689 `"0689"', add
label define occ_lbl 0690 `"0690"', add
label define occ_lbl 0691 `"0691"', add
label define occ_lbl 0692 `"0692"', add
label define occ_lbl 0693 `"0693"', add
label define occ_lbl 0694 `"0694"', add
label define occ_lbl 0695 `"0695"', add
label define occ_lbl 0696 `"0696"', add
label define occ_lbl 0697 `"0697"', add
label define occ_lbl 0698 `"0698"', add
label define occ_lbl 0699 `"0699"', add
label define occ_lbl 0700 `"0700"', add
label define occ_lbl 0701 `"0701"', add
label define occ_lbl 0702 `"0702"', add
label define occ_lbl 0703 `"0703"', add
label define occ_lbl 0704 `"0704"', add
label define occ_lbl 0705 `"0705"', add
label define occ_lbl 0706 `"0706"', add
label define occ_lbl 0707 `"0707"', add
label define occ_lbl 0708 `"0708"', add
label define occ_lbl 0709 `"0709"', add
label define occ_lbl 0710 `"0710"', add
label define occ_lbl 0711 `"0711"', add
label define occ_lbl 0712 `"0712"', add
label define occ_lbl 0713 `"0713"', add
label define occ_lbl 0714 `"0714"', add
label define occ_lbl 0715 `"0715"', add
label define occ_lbl 0716 `"0716"', add
label define occ_lbl 0717 `"0717"', add
label define occ_lbl 0718 `"0718"', add
label define occ_lbl 0719 `"0719"', add
label define occ_lbl 0720 `"0720"', add
label define occ_lbl 0721 `"0721"', add
label define occ_lbl 0722 `"0722"', add
label define occ_lbl 0723 `"0723"', add
label define occ_lbl 0724 `"0724"', add
label define occ_lbl 0725 `"0725"', add
label define occ_lbl 0726 `"0726"', add
label define occ_lbl 0727 `"0727"', add
label define occ_lbl 0728 `"0728"', add
label define occ_lbl 0729 `"0729"', add
label define occ_lbl 0730 `"0730"', add
label define occ_lbl 0731 `"0731"', add
label define occ_lbl 0732 `"0732"', add
label define occ_lbl 0733 `"0733"', add
label define occ_lbl 0734 `"0734"', add
label define occ_lbl 0735 `"0735"', add
label define occ_lbl 0736 `"0736"', add
label define occ_lbl 0737 `"0737"', add
label define occ_lbl 0738 `"0738"', add
label define occ_lbl 0739 `"0739"', add
label define occ_lbl 0740 `"0740"', add
label define occ_lbl 0741 `"0741"', add
label define occ_lbl 0742 `"0742"', add
label define occ_lbl 0743 `"0743"', add
label define occ_lbl 0744 `"0744"', add
label define occ_lbl 0745 `"0745"', add
label define occ_lbl 0746 `"0746"', add
label define occ_lbl 0747 `"0747"', add
label define occ_lbl 0748 `"0748"', add
label define occ_lbl 0749 `"0749"', add
label define occ_lbl 0750 `"0750"', add
label define occ_lbl 0751 `"0751"', add
label define occ_lbl 0752 `"0752"', add
label define occ_lbl 0753 `"0753"', add
label define occ_lbl 0754 `"0754"', add
label define occ_lbl 0755 `"0755"', add
label define occ_lbl 0756 `"0756"', add
label define occ_lbl 0757 `"0757"', add
label define occ_lbl 0758 `"0758"', add
label define occ_lbl 0759 `"0759"', add
label define occ_lbl 0760 `"0760"', add
label define occ_lbl 0761 `"0761"', add
label define occ_lbl 0762 `"0762"', add
label define occ_lbl 0763 `"0763"', add
label define occ_lbl 0764 `"0764"', add
label define occ_lbl 0765 `"0765"', add
label define occ_lbl 0766 `"0766"', add
label define occ_lbl 0767 `"0767"', add
label define occ_lbl 0768 `"0768"', add
label define occ_lbl 0769 `"0769"', add
label define occ_lbl 0770 `"0770"', add
label define occ_lbl 0771 `"0771"', add
label define occ_lbl 0772 `"0772"', add
label define occ_lbl 0773 `"0773"', add
label define occ_lbl 0774 `"0774"', add
label define occ_lbl 0775 `"0775"', add
label define occ_lbl 0776 `"0776"', add
label define occ_lbl 0777 `"0777"', add
label define occ_lbl 0778 `"0778"', add
label define occ_lbl 0779 `"0779"', add
label define occ_lbl 0780 `"0780"', add
label define occ_lbl 0781 `"0781"', add
label define occ_lbl 0782 `"0782"', add
label define occ_lbl 0783 `"0783"', add
label define occ_lbl 0784 `"0784"', add
label define occ_lbl 0785 `"0785"', add
label define occ_lbl 0786 `"0786"', add
label define occ_lbl 0787 `"0787"', add
label define occ_lbl 0788 `"0788"', add
label define occ_lbl 0789 `"0789"', add
label define occ_lbl 0790 `"0790"', add
label define occ_lbl 0791 `"0791"', add
label define occ_lbl 0792 `"0792"', add
label define occ_lbl 0793 `"0793"', add
label define occ_lbl 0794 `"0794"', add
label define occ_lbl 0795 `"0795"', add
label define occ_lbl 0796 `"0796"', add
label define occ_lbl 0797 `"0797"', add
label define occ_lbl 0798 `"0798"', add
label define occ_lbl 0799 `"0799"', add
label define occ_lbl 0800 `"0800"', add
label define occ_lbl 0801 `"0801"', add
label define occ_lbl 0802 `"0802"', add
label define occ_lbl 0803 `"0803"', add
label define occ_lbl 0804 `"0804"', add
label define occ_lbl 0805 `"0805"', add
label define occ_lbl 0806 `"0806"', add
label define occ_lbl 0807 `"0807"', add
label define occ_lbl 0808 `"0808"', add
label define occ_lbl 0809 `"0809"', add
label define occ_lbl 0810 `"0810"', add
label define occ_lbl 0811 `"0811"', add
label define occ_lbl 0812 `"0812"', add
label define occ_lbl 0813 `"0813"', add
label define occ_lbl 0814 `"0814"', add
label define occ_lbl 0815 `"0815"', add
label define occ_lbl 0816 `"0816"', add
label define occ_lbl 0817 `"0817"', add
label define occ_lbl 0818 `"0818"', add
label define occ_lbl 0819 `"0819"', add
label define occ_lbl 0820 `"0820"', add
label define occ_lbl 0821 `"0821"', add
label define occ_lbl 0822 `"0822"', add
label define occ_lbl 0823 `"0823"', add
label define occ_lbl 0824 `"0824"', add
label define occ_lbl 0825 `"0825"', add
label define occ_lbl 0826 `"0826"', add
label define occ_lbl 0827 `"0827"', add
label define occ_lbl 0828 `"0828"', add
label define occ_lbl 0829 `"0829"', add
label define occ_lbl 0830 `"0830"', add
label define occ_lbl 0831 `"0831"', add
label define occ_lbl 0832 `"0832"', add
label define occ_lbl 0833 `"0833"', add
label define occ_lbl 0834 `"0834"', add
label define occ_lbl 0835 `"0835"', add
label define occ_lbl 0836 `"0836"', add
label define occ_lbl 0837 `"0837"', add
label define occ_lbl 0838 `"0838"', add
label define occ_lbl 0839 `"0839"', add
label define occ_lbl 0840 `"0840"', add
label define occ_lbl 0841 `"0841"', add
label define occ_lbl 0842 `"0842"', add
label define occ_lbl 0843 `"0843"', add
label define occ_lbl 0844 `"0844"', add
label define occ_lbl 0845 `"0845"', add
label define occ_lbl 0846 `"0846"', add
label define occ_lbl 0847 `"0847"', add
label define occ_lbl 0848 `"0848"', add
label define occ_lbl 0849 `"0849"', add
label define occ_lbl 0850 `"0850"', add
label define occ_lbl 0851 `"0851"', add
label define occ_lbl 0852 `"0852"', add
label define occ_lbl 0853 `"0853"', add
label define occ_lbl 0854 `"0854"', add
label define occ_lbl 0855 `"0855"', add
label define occ_lbl 0856 `"0856"', add
label define occ_lbl 0857 `"0857"', add
label define occ_lbl 0858 `"0858"', add
label define occ_lbl 0859 `"0859"', add
label define occ_lbl 0860 `"0860"', add
label define occ_lbl 0861 `"0861"', add
label define occ_lbl 0862 `"0862"', add
label define occ_lbl 0863 `"0863"', add
label define occ_lbl 0864 `"0864"', add
label define occ_lbl 0865 `"0865"', add
label define occ_lbl 0866 `"0866"', add
label define occ_lbl 0867 `"0867"', add
label define occ_lbl 0868 `"0868"', add
label define occ_lbl 0869 `"0869"', add
label define occ_lbl 0870 `"0870"', add
label define occ_lbl 0871 `"0871"', add
label define occ_lbl 0872 `"0872"', add
label define occ_lbl 0873 `"0873"', add
label define occ_lbl 0874 `"0874"', add
label define occ_lbl 0875 `"0875"', add
label define occ_lbl 0876 `"0876"', add
label define occ_lbl 0877 `"0877"', add
label define occ_lbl 0878 `"0878"', add
label define occ_lbl 0879 `"0879"', add
label define occ_lbl 0880 `"0880"', add
label define occ_lbl 0881 `"0881"', add
label define occ_lbl 0882 `"0882"', add
label define occ_lbl 0883 `"0883"', add
label define occ_lbl 0884 `"0884"', add
label define occ_lbl 0885 `"0885"', add
label define occ_lbl 0886 `"0886"', add
label define occ_lbl 0887 `"0887"', add
label define occ_lbl 0888 `"0888"', add
label define occ_lbl 0889 `"0889"', add
label define occ_lbl 0890 `"0890"', add
label define occ_lbl 0891 `"0891"', add
label define occ_lbl 0892 `"0892"', add
label define occ_lbl 0893 `"0893"', add
label define occ_lbl 0894 `"0894"', add
label define occ_lbl 0895 `"0895"', add
label define occ_lbl 0896 `"0896"', add
label define occ_lbl 0897 `"0897"', add
label define occ_lbl 0898 `"0898"', add
label define occ_lbl 0899 `"0899"', add
label define occ_lbl 0900 `"0900"', add
label define occ_lbl 0901 `"0901"', add
label define occ_lbl 0902 `"0902"', add
label define occ_lbl 0903 `"0903"', add
label define occ_lbl 0904 `"0904"', add
label define occ_lbl 0905 `"0905"', add
label define occ_lbl 0906 `"0906"', add
label define occ_lbl 0907 `"0907"', add
label define occ_lbl 0908 `"0908"', add
label define occ_lbl 0909 `"0909"', add
label define occ_lbl 0910 `"0910"', add
label define occ_lbl 0911 `"0911"', add
label define occ_lbl 0912 `"0912"', add
label define occ_lbl 0913 `"0913"', add
label define occ_lbl 0914 `"0914"', add
label define occ_lbl 0915 `"0915"', add
label define occ_lbl 0916 `"0916"', add
label define occ_lbl 0917 `"0917"', add
label define occ_lbl 0918 `"0918"', add
label define occ_lbl 0919 `"0919"', add
label define occ_lbl 0920 `"0920"', add
label define occ_lbl 0921 `"0921"', add
label define occ_lbl 0922 `"0922"', add
label define occ_lbl 0923 `"0923"', add
label define occ_lbl 0924 `"0924"', add
label define occ_lbl 0925 `"0925"', add
label define occ_lbl 0926 `"0926"', add
label define occ_lbl 0927 `"0927"', add
label define occ_lbl 0928 `"0928"', add
label define occ_lbl 0929 `"0929"', add
label define occ_lbl 0930 `"0930"', add
label define occ_lbl 0931 `"0931"', add
label define occ_lbl 0932 `"0932"', add
label define occ_lbl 0933 `"0933"', add
label define occ_lbl 0934 `"0934"', add
label define occ_lbl 0935 `"0935"', add
label define occ_lbl 0936 `"0936"', add
label define occ_lbl 0937 `"0937"', add
label define occ_lbl 0938 `"0938"', add
label define occ_lbl 0939 `"0939"', add
label define occ_lbl 0940 `"0940"', add
label define occ_lbl 0941 `"0941"', add
label define occ_lbl 0942 `"0942"', add
label define occ_lbl 0943 `"0943"', add
label define occ_lbl 0944 `"0944"', add
label define occ_lbl 0945 `"0945"', add
label define occ_lbl 0946 `"0946"', add
label define occ_lbl 0947 `"0947"', add
label define occ_lbl 0948 `"0948"', add
label define occ_lbl 0949 `"0949"', add
label define occ_lbl 0950 `"0950"', add
label define occ_lbl 0951 `"0951"', add
label define occ_lbl 0952 `"0952"', add
label define occ_lbl 0953 `"0953"', add
label define occ_lbl 0954 `"0954"', add
label define occ_lbl 0955 `"0955"', add
label define occ_lbl 0956 `"0956"', add
label define occ_lbl 0957 `"0957"', add
label define occ_lbl 0958 `"0958"', add
label define occ_lbl 0959 `"0959"', add
label define occ_lbl 0960 `"0960"', add
label define occ_lbl 0961 `"0961"', add
label define occ_lbl 0962 `"0962"', add
label define occ_lbl 0963 `"0963"', add
label define occ_lbl 0964 `"0964"', add
label define occ_lbl 0965 `"0965"', add
label define occ_lbl 0966 `"0966"', add
label define occ_lbl 0967 `"0967"', add
label define occ_lbl 0968 `"0968"', add
label define occ_lbl 0969 `"0969"', add
label define occ_lbl 0970 `"0970"', add
label define occ_lbl 0971 `"0971"', add
label define occ_lbl 0972 `"0972"', add
label define occ_lbl 0973 `"0973"', add
label define occ_lbl 0974 `"0974"', add
label define occ_lbl 0975 `"0975"', add
label define occ_lbl 0976 `"0976"', add
label define occ_lbl 0977 `"0977"', add
label define occ_lbl 0978 `"0978"', add
label define occ_lbl 0979 `"0979"', add
label define occ_lbl 0980 `"0980"', add
label define occ_lbl 0981 `"0981"', add
label define occ_lbl 0982 `"0982"', add
label define occ_lbl 0983 `"0983"', add
label define occ_lbl 0984 `"0984"', add
label define occ_lbl 0985 `"0985"', add
label define occ_lbl 0986 `"0986"', add
label define occ_lbl 0987 `"0987"', add
label define occ_lbl 0988 `"0988"', add
label define occ_lbl 0989 `"0989"', add
label define occ_lbl 0990 `"0990"', add
label define occ_lbl 0991 `"0991"', add
label define occ_lbl 0992 `"0992"', add
label define occ_lbl 0993 `"0993"', add
label define occ_lbl 0994 `"0994"', add
label define occ_lbl 0995 `"0995"', add
label define occ_lbl 0996 `"0996"', add
label define occ_lbl 0997 `"0997"', add
label define occ_lbl 0998 `"0998"', add
label define occ_lbl 0999 `"0999"', add
label values occ occ_lbl

label define occ2010_lbl 0010 `"Chief executives and legislators/public administration"'
label define occ2010_lbl 0020 `"General and Operations Managers"', add
label define occ2010_lbl 0030 `"Managers in Marketing, Advertising, and Public Relations"', add
label define occ2010_lbl 0100 `"Administrative Services Managers"', add
label define occ2010_lbl 0110 `"Computer and Information Systems Managers"', add
label define occ2010_lbl 0120 `"Financial Managers"', add
label define occ2010_lbl 0130 `"Human Resources Managers"', add
label define occ2010_lbl 0140 `"Industrial Production Managers"', add
label define occ2010_lbl 0150 `"Purchasing Managers"', add
label define occ2010_lbl 0160 `"Transportation, Storage, and Distribution Managers"', add
label define occ2010_lbl 0205 `"Farmers, Ranchers, and Other Agricultural Managers"', add
label define occ2010_lbl 0220 `"Constructions Managers"', add
label define occ2010_lbl 0230 `"Education Administrators"', add
label define occ2010_lbl 0300 `"Architectural and Engineering Managers"', add
label define occ2010_lbl 0310 `"Food Service and Lodging Managers"', add
label define occ2010_lbl 0320 `"Funeral Directors"', add
label define occ2010_lbl 0330 `"Gaming Managers"', add
label define occ2010_lbl 0350 `"Medical and Health Services Managers"', add
label define occ2010_lbl 0360 `"Natural Science Managers"', add
label define occ2010_lbl 0410 `"Property, Real Estate, and Community Association Managers"', add
label define occ2010_lbl 0420 `"Social and Community Service Managers"', add
label define occ2010_lbl 0430 `"Managers, nec (including Postmasters)"', add
label define occ2010_lbl 0500 `"Agents and Business Managers of Artists, Performers, and Athletes"', add
label define occ2010_lbl 0510 `"Buyers and Purchasing Agents, Farm Products"', add
label define occ2010_lbl 0520 `"Wholesale and Retail Buyers, Except Farm Products"', add
label define occ2010_lbl 0530 `"Purchasing Agents, Except Wholesale, Retail, and Farm Products"', add
label define occ2010_lbl 0540 `"Claims Adjusters, Appraisers, Examiners, and Investigators"', add
label define occ2010_lbl 0560 `"Compliance Officers, Except Agriculture"', add
label define occ2010_lbl 0600 `"Cost Estimators"', add
label define occ2010_lbl 0620 `"Human Resources, Training, and Labor Relations Specialists"', add
label define occ2010_lbl 0700 `"Logisticians"', add
label define occ2010_lbl 0710 `"Management Analysts"', add
label define occ2010_lbl 0720 `"Meeting and Convention Planners"', add
label define occ2010_lbl 0730 `"Other Business Operations and Management Specialists"', add
label define occ2010_lbl 0800 `"Accountants and Auditors"', add
label define occ2010_lbl 0810 `"Appraisers and Assessors of Real Estate"', add
label define occ2010_lbl 0820 `"Budget Analysts"', add
label define occ2010_lbl 0830 `"Credit Analysts"', add
label define occ2010_lbl 0840 `"Financial Analysts"', add
label define occ2010_lbl 0850 `"Personal Financial Advisors"', add
label define occ2010_lbl 0860 `"Insurance Underwriters"', add
label define occ2010_lbl 0900 `"Financial Examiners"', add
label define occ2010_lbl 0910 `"Credit Counselors and Loan Officers"', add
label define occ2010_lbl 0930 `"Tax Examiners and Collectors, and Revenue Agents"', add
label define occ2010_lbl 0940 `"Tax Preparers"', add
label define occ2010_lbl 0950 `"Financial Specialists, nec"', add
label define occ2010_lbl 1000 `"Computer Scientists and Systems Analysts/Network systems Analysts/Web Developers"', add
label define occ2010_lbl 1010 `"Computer Programmers"', add
label define occ2010_lbl 1020 `"Software Developers, Applications and Systems Software"', add
label define occ2010_lbl 1050 `"Computer Support Specialists"', add
label define occ2010_lbl 1060 `"Database Administrators"', add
label define occ2010_lbl 1100 `"Network and Computer Systems Administrators"', add
label define occ2010_lbl 1200 `"Actuaries"', add
label define occ2010_lbl 1220 `"Operations Research Analysts"', add
label define occ2010_lbl 1230 `"Statisticians"', add
label define occ2010_lbl 1240 `"Mathematical science occupations, nec"', add
label define occ2010_lbl 1300 `"Architects, Except Naval"', add
label define occ2010_lbl 1310 `"Surveyors, Cartographers, and Photogrammetrists"', add
label define occ2010_lbl 1320 `"Aerospace Engineers"', add
label define occ2010_lbl 1350 `"Chemical Engineers"', add
label define occ2010_lbl 1360 `"Civil Engineers"', add
label define occ2010_lbl 1400 `"Computer Hardware Engineers"', add
label define occ2010_lbl 1410 `"Electrical and Electronics Engineers"', add
label define occ2010_lbl 1420 `"Environmental Engineers"', add
label define occ2010_lbl 1430 `"Industrial Engineers, including Health and Safety"', add
label define occ2010_lbl 1440 `"Marine Engineers and Naval Architects"', add
label define occ2010_lbl 1450 `"Materials Engineers"', add
label define occ2010_lbl 1460 `"Mechanical Engineers"', add
label define occ2010_lbl 1520 `"Petroleum, mining and geological engineers, including mining safety engineers"', add
label define occ2010_lbl 1530 `"Engineers, nec"', add
label define occ2010_lbl 1540 `"Drafters"', add
label define occ2010_lbl 1550 `"Engineering Technicians, Except Drafters"', add
label define occ2010_lbl 1560 `"Surveying and Mapping Technicians"', add
label define occ2010_lbl 1600 `"Agricultural and Food Scientists"', add
label define occ2010_lbl 1610 `"Biological Scientists"', add
label define occ2010_lbl 1640 `"Conservation Scientists and Foresters"', add
label define occ2010_lbl 1650 `"Medical Scientists, and Life Scientists, All Other"', add
label define occ2010_lbl 1700 `"Astronomers and Physicists"', add
label define occ2010_lbl 1710 `"Atmospheric and Space Scientists"', add
label define occ2010_lbl 1720 `"Chemists and Materials Scientists"', add
label define occ2010_lbl 1740 `"Environmental Scientists and Geoscientists"', add
label define occ2010_lbl 1760 `"Physical Scientists, nec"', add
label define occ2010_lbl 1800 `"Economists and market researchers"', add
label define occ2010_lbl 1820 `"Psychologists"', add
label define occ2010_lbl 1830 `"Urban and Regional Planners"', add
label define occ2010_lbl 1840 `"Social Scientists, nec"', add
label define occ2010_lbl 1900 `"Agricultural and Food Science Technicians"', add
label define occ2010_lbl 1910 `"Biological Technicians"', add
label define occ2010_lbl 1920 `"Chemical Technicians"', add
label define occ2010_lbl 1930 `"Geological and Petroleum Technicians, and Nuclear Technicians"', add
label define occ2010_lbl 1960 `"Life, Physical, and Social Science Technicians, nec"', add
label define occ2010_lbl 1980 `"Professional, Research, or Technical Workers, nec"', add
label define occ2010_lbl 2000 `"Counselors"', add
label define occ2010_lbl 2010 `"Social Workers"', add
label define occ2010_lbl 2020 `"Community and Social Service Specialists, nec"', add
label define occ2010_lbl 2040 `"Clergy"', add
label define occ2010_lbl 2050 `"Directors, Religious Activities and Education"', add
label define occ2010_lbl 2060 `"Religious Workers, nec"', add
label define occ2010_lbl 2100 `"Lawyers, and judges, magistrates, and other judicial workers"', add
label define occ2010_lbl 2140 `"Paralegals and Legal Assistants"', add
label define occ2010_lbl 2150 `"Legal Support Workers, nec"', add
label define occ2010_lbl 2200 `"Postsecondary Teachers"', add
label define occ2010_lbl 2300 `"Preschool and Kindergarten Teachers"', add
label define occ2010_lbl 2310 `"Elementary and Middle School Teachers"', add
label define occ2010_lbl 2320 `"Secondary School Teachers"', add
label define occ2010_lbl 2330 `"Special Education Teachers"', add
label define occ2010_lbl 2340 `"Other Teachers and Instructors"', add
label define occ2010_lbl 2400 `"Archivists, Curators, and Museum Technicians"', add
label define occ2010_lbl 2430 `"Librarians"', add
label define occ2010_lbl 2440 `"Library Technicians"', add
label define occ2010_lbl 2540 `"Teacher Assistants"', add
label define occ2010_lbl 2550 `"Education, Training, and Library Workers, nec"', add
label define occ2010_lbl 2600 `"Artists and Related Workers"', add
label define occ2010_lbl 2630 `"Designers"', add
label define occ2010_lbl 2700 `"Actors, Producers, and Directors"', add
label define occ2010_lbl 2720 `"Athletes, Coaches, Umpires, and Related Workers"', add
label define occ2010_lbl 2740 `"Dancers and Choreographers"', add
label define occ2010_lbl 2750 `"Musicians, Singers, and Related Workers"', add
label define occ2010_lbl 2760 `"Entertainers and Performers, Sports and Related Workers, All Other"', add
label define occ2010_lbl 2800 `"Announcers"', add
label define occ2010_lbl 2810 `"Editors, News Analysts, Reporters, and Correspondents"', add
label define occ2010_lbl 2825 `"Public Relations Specialists"', add
label define occ2010_lbl 2840 `"Technical Writers"', add
label define occ2010_lbl 2850 `"Writers and Authors"', add
label define occ2010_lbl 2860 `"Media and Communication Workers, nec"', add
label define occ2010_lbl 2900 `"Broadcast and Sound Engineering Technicians and Radio Operators, and media and communication equipment workers, all other"', add
label define occ2010_lbl 2910 `"Photographers"', add
label define occ2010_lbl 2920 `"Television, Video, and Motion Picture Camera Operators and Editors"', add
label define occ2010_lbl 3000 `"Chiropractors"', add
label define occ2010_lbl 3010 `"Dentists"', add
label define occ2010_lbl 3030 `"Dieticians and Nutritionists"', add
label define occ2010_lbl 3040 `"Optometrists"', add
label define occ2010_lbl 3050 `"Pharmacists"', add
label define occ2010_lbl 3060 `"Physicians and Surgeons"', add
label define occ2010_lbl 3110 `"Physician Assistants"', add
label define occ2010_lbl 3120 `"Podiatrists"', add
label define occ2010_lbl 3130 `"Registered Nurses"', add
label define occ2010_lbl 3140 `"Audiologists"', add
label define occ2010_lbl 3150 `"Occupational Therapists"', add
label define occ2010_lbl 3160 `"Physical Therapists"', add
label define occ2010_lbl 3200 `"Radiation Therapists"', add
label define occ2010_lbl 3210 `"Recreational Therapists"', add
label define occ2010_lbl 3220 `"Respiratory Therapists"', add
label define occ2010_lbl 3230 `"Speech Language Pathologists"', add
label define occ2010_lbl 3240 `"Therapists, nec"', add
label define occ2010_lbl 3250 `"Veterinarians"', add
label define occ2010_lbl 3260 `"Health Diagnosing and Treating Practitioners, nec"', add
label define occ2010_lbl 3300 `"Clinical Laboratory Technologists and Technicians"', add
label define occ2010_lbl 3310 `"Dental Hygienists"', add
label define occ2010_lbl 3320 `"Diagnostic Related Technologists and Technicians"', add
label define occ2010_lbl 3400 `"Emergency Medical Technicians and Paramedics"', add
label define occ2010_lbl 3410 `"Health Diagnosing and Treating Practitioner Support Technicians"', add
label define occ2010_lbl 3500 `"Licensed Practical and Licensed Vocational Nurses"', add
label define occ2010_lbl 3510 `"Medical Records and Health Information Technicians"', add
label define occ2010_lbl 3520 `"Opticians, Dispensing"', add
label define occ2010_lbl 3530 `"Health Technologists and Technicians, nec"', add
label define occ2010_lbl 3540 `"Healthcare Practitioners and Technical Occupations, nec"', add
label define occ2010_lbl 3600 `"Nursing, Psychiatric, and Home Health Aides"', add
label define occ2010_lbl 3610 `"Occupational Therapy Assistants and Aides"', add
label define occ2010_lbl 3620 `"Physical Therapist Assistants and Aides"', add
label define occ2010_lbl 3630 `"Massage Therapists"', add
label define occ2010_lbl 3640 `"Dental Assistants"', add
label define occ2010_lbl 3650 `"Medical Assistants and Other Healthcare Support Occupations, nec"', add
label define occ2010_lbl 3700 `"First-Line Supervisors of Correctional Officers"', add
label define occ2010_lbl 3710 `"First-Line Supervisors of Police and Detectives"', add
label define occ2010_lbl 3720 `"First-Line Supervisors of Fire Fighting and Prevention Workers"', add
label define occ2010_lbl 3730 `"Supervisors, Protective Service Workers, All Other"', add
label define occ2010_lbl 3740 `"Firefighters"', add
label define occ2010_lbl 3750 `"Fire Inspectors"', add
label define occ2010_lbl 3800 `"Sheriffs, Bailiffs, Correctional Officers, and Jailers"', add
label define occ2010_lbl 3820 `"Police Officers and Detectives"', add
label define occ2010_lbl 3900 `"Animal Control"', add
label define occ2010_lbl 3910 `"Private Detectives and Investigators"', add
label define occ2010_lbl 3930 `"Security Guards and Gaming Surveillance Officers"', add
label define occ2010_lbl 3940 `"Crossing Guards"', add
label define occ2010_lbl 3950 `"Law enforcement workers, nec"', add
label define occ2010_lbl 4000 `"Chefs and Cooks"', add
label define occ2010_lbl 4010 `"First-Line Supervisors of Food Preparation and Serving Workers"', add
label define occ2010_lbl 4030 `"Food Preparation Workers"', add
label define occ2010_lbl 4040 `"Bartenders"', add
label define occ2010_lbl 4050 `"Combined Food Preparation and Serving Workers, Including Fast Food"', add
label define occ2010_lbl 4060 `"Counter Attendant, Cafeteria, Food Concession, and Coffee Shop"', add
label define occ2010_lbl 4110 `"Waiters and Waitresses"', add
label define occ2010_lbl 4120 `"Food Servers, Nonrestaurant"', add
label define occ2010_lbl 4130 `"Food preparation and serving related workers, nec"', add
label define occ2010_lbl 4140 `"Dishwashers"', add
label define occ2010_lbl 4150 `"Host and Hostesses, Restaurant, Lounge, and Coffee Shop"', add
label define occ2010_lbl 4200 `"First-Line Supervisors of Housekeeping and Janitorial Workers"', add
label define occ2010_lbl 4210 `"First-Line Supervisors of Landscaping, Lawn Service, and Groundskeeping Workers"', add
label define occ2010_lbl 4220 `"Janitors and Building Cleaners"', add
label define occ2010_lbl 4230 `"Maids and Housekeeping Cleaners"', add
label define occ2010_lbl 4240 `"Pest Control Workers"', add
label define occ2010_lbl 4250 `"Grounds Maintenance Workers"', add
label define occ2010_lbl 4300 `"First-Line Supervisors of Gaming Workers"', add
label define occ2010_lbl 4320 `"First-Line Supervisors of Personal Service Workers"', add
label define occ2010_lbl 4340 `"Animal Trainers"', add
label define occ2010_lbl 4350 `"Nonfarm Animal Caretakers"', add
label define occ2010_lbl 4400 `"Gaming Services Workers"', add
label define occ2010_lbl 4420 `"Ushers, Lobby Attendants, and Ticket Takers"', add
label define occ2010_lbl 4430 `"Entertainment Attendants and Related Workers, nec"', add
label define occ2010_lbl 4460 `"Funeral Service Workers and Embalmers"', add
label define occ2010_lbl 4500 `"Barbers"', add
label define occ2010_lbl 4510 `"Hairdressers, Hairstylists, and Cosmetologists"', add
label define occ2010_lbl 4520 `"Personal Appearance Workers, nec"', add
label define occ2010_lbl 4530 `"Baggage Porters, Bellhops, and Concierges"', add
label define occ2010_lbl 4540 `"Tour and Travel Guides"', add
label define occ2010_lbl 4600 `"Childcare Workers"', add
label define occ2010_lbl 4610 `"Personal Care Aides"', add
label define occ2010_lbl 4620 `"Recreation and Fitness Workers"', add
label define occ2010_lbl 4640 `"Residential Advisors"', add
label define occ2010_lbl 4650 `"Personal Care and Service Workers, All Other"', add
label define occ2010_lbl 4700 `"First-Line Supervisors of Sales Workers"', add
label define occ2010_lbl 4720 `"Cashiers"', add
label define occ2010_lbl 4740 `"Counter and Rental Clerks"', add
label define occ2010_lbl 4750 `"Parts Salespersons"', add
label define occ2010_lbl 4760 `"Retail Salespersons"', add
label define occ2010_lbl 4800 `"Advertising Sales Agents"', add
label define occ2010_lbl 4810 `"Insurance Sales Agents"', add
label define occ2010_lbl 4820 `"Securities, Commodities, and Financial Services Sales Agents"', add
label define occ2010_lbl 4830 `"Travel Agents"', add
label define occ2010_lbl 4840 `"Sales Representatives, Services, All Other"', add
label define occ2010_lbl 4850 `"Sales Representatives, Wholesale and Manufacturing"', add
label define occ2010_lbl 4900 `"Models, Demonstrators, and Product Promoters"', add
label define occ2010_lbl 4920 `"Real Estate Brokers and Sales Agents"', add
label define occ2010_lbl 4930 `"Sales Engineers"', add
label define occ2010_lbl 4940 `"Telemarketers"', add
label define occ2010_lbl 4950 `"Door-to-Door Sales Workers, News and Street Vendors, and Related Workers"', add
label define occ2010_lbl 4965 `"Sales and Related Workers, All Other"', add
label define occ2010_lbl 5000 `"First-Line Supervisors of Office and Administrative Support Workers"', add
label define occ2010_lbl 5010 `"Switchboard Operators, Including Answering Service"', add
label define occ2010_lbl 5020 `"Telephone Operators"', add
label define occ2010_lbl 5030 `"Communications Equipment Operators, All Other"', add
label define occ2010_lbl 5100 `"Bill and Account Collectors"', add
label define occ2010_lbl 5110 `"Billing and Posting Clerks"', add
label define occ2010_lbl 5120 `"Bookkeeping, Accounting, and Auditing Clerks"', add
label define occ2010_lbl 5130 `"Gaming Cage Workers"', add
label define occ2010_lbl 5140 `"Payroll and Timekeeping Clerks"', add
label define occ2010_lbl 5150 `"Procurement Clerks"', add
label define occ2010_lbl 5160 `"Bank Tellers"', add
label define occ2010_lbl 5165 `"Financial Clerks, nec"', add
label define occ2010_lbl 5200 `"Brokerage Clerks"', add
label define occ2010_lbl 5220 `"Court, Municipal, and License Clerks"', add
label define occ2010_lbl 5230 `"Credit Authorizers, Checkers, and Clerks"', add
label define occ2010_lbl 5240 `"Customer Service Representatives"', add
label define occ2010_lbl 5250 `"Eligibility Interviewers, Government Programs"', add
label define occ2010_lbl 5260 `"File Clerks"', add
label define occ2010_lbl 5300 `"Hotel, Motel, and Resort Desk Clerks"', add
label define occ2010_lbl 5310 `"Interviewers, Except Eligibility and Loan"', add
label define occ2010_lbl 5320 `"Library Assistants, Clerical"', add
label define occ2010_lbl 5330 `"Loan Interviewers and Clerks"', add
label define occ2010_lbl 5340 `"New Account Clerks"', add
label define occ2010_lbl 5350 `"Correspondent clerks and order clerks"', add
label define occ2010_lbl 5360 `"Human Resources Assistants, Except Payroll and Timekeeping"', add
label define occ2010_lbl 5400 `"Receptionists and Information Clerks"', add
label define occ2010_lbl 5410 `"Reservation and Transportation Ticket Agents and Travel Clerks"', add
label define occ2010_lbl 5420 `"Information and Record Clerks, All Other"', add
label define occ2010_lbl 5500 `"Cargo and Freight Agents"', add
label define occ2010_lbl 5510 `"Couriers and Messengers"', add
label define occ2010_lbl 5520 `"Dispatchers"', add
label define occ2010_lbl 5530 `"Meter Readers, Utilities"', add
label define occ2010_lbl 5540 `"Postal Service Clerks"', add
label define occ2010_lbl 5550 `"Postal Service Mail Carriers"', add
label define occ2010_lbl 5560 `"Postal Service Mail Sorters, Processors, and Processing Machine Operators"', add
label define occ2010_lbl 5600 `"Production, Planning, and Expediting Clerks"', add
label define occ2010_lbl 5610 `"Shipping, Receiving, and Traffic Clerks"', add
label define occ2010_lbl 5620 `"Stock Clerks and Order Fillers"', add
label define occ2010_lbl 5630 `"Weighers, Measurers, Checkers, and Samplers, Recordkeeping"', add
label define occ2010_lbl 5700 `"Secretaries and Administrative Assistants"', add
label define occ2010_lbl 5800 `"Computer Operators"', add
label define occ2010_lbl 5810 `"Data Entry Keyers"', add
label define occ2010_lbl 5820 `"Word Processors and Typists"', add
label define occ2010_lbl 5840 `"Insurance Claims and Policy Processing Clerks"', add
label define occ2010_lbl 5850 `"Mail Clerks and Mail Machine Operators, Except Postal Service"', add
label define occ2010_lbl 5860 `"Office Clerks, General"', add
label define occ2010_lbl 5900 `"Office Machine Operators, Except Computer"', add
label define occ2010_lbl 5910 `"Proofreaders and Copy Markers"', add
label define occ2010_lbl 5920 `"Statistical Assistants"', add
label define occ2010_lbl 5940 `"Office and administrative support workers, nec"', add
label define occ2010_lbl 6005 `"First-Line Supervisors of Farming, Fishing, and Forestry Workers"', add
label define occ2010_lbl 6010 `"Agricultural Inspectors"', add
label define occ2010_lbl 6040 `"Graders and Sorters, Agricultural Products"', add
label define occ2010_lbl 6050 `"Agricultural workers, nec"', add
label define occ2010_lbl 6100 `"Fishing and hunting workers"', add
label define occ2010_lbl 6120 `"Forest and Conservation Workers"', add
label define occ2010_lbl 6130 `"Logging Workers"', add
label define occ2010_lbl 6200 `"First-Line Supervisors of Construction Trades and Extraction Workers"', add
label define occ2010_lbl 6210 `"Boilermakers"', add
label define occ2010_lbl 6220 `"Brickmasons, Blockmasons, and Stonemasons"', add
label define occ2010_lbl 6230 `"Carpenters"', add
label define occ2010_lbl 6240 `"Carpet, Floor, and Tile Installers and Finishers"', add
label define occ2010_lbl 6250 `"Cement Masons, Concrete Finishers, and Terrazzo Workers"', add
label define occ2010_lbl 6260 `"Construction Laborers"', add
label define occ2010_lbl 6300 `"Paving, Surfacing, and Tamping Equipment Operators"', add
label define occ2010_lbl 6320 `"Construction equipment operators except paving, surfacing, and tamping equipment operators"', add
label define occ2010_lbl 6330 `"Drywall Installers, Ceiling Tile Installers, and Tapers"', add
label define occ2010_lbl 6355 `"Electricians"', add
label define occ2010_lbl 6360 `"Glaziers"', add
label define occ2010_lbl 6400 `"Insulation Workers"', add
label define occ2010_lbl 6420 `"Painters, Construction and Maintenance"', add
label define occ2010_lbl 6430 `"Paperhangers"', add
label define occ2010_lbl 6440 `"Pipelayers, Plumbers, Pipefitters, and Steamfitters"', add
label define occ2010_lbl 6460 `"Plasterers and Stucco Masons"', add
label define occ2010_lbl 6500 `"Reinforcing Iron and Rebar Workers"', add
label define occ2010_lbl 6515 `"Roofers"', add
label define occ2010_lbl 6520 `"Sheet Metal Workers, metal-working"', add
label define occ2010_lbl 6530 `"Structural Iron and Steel Workers"', add
label define occ2010_lbl 6600 `"Helpers, Construction Trades"', add
label define occ2010_lbl 6660 `"Construction and Building Inspectors"', add
label define occ2010_lbl 6700 `"Elevator Installers and Repairers"', add
label define occ2010_lbl 6710 `"Fence Erectors"', add
label define occ2010_lbl 6720 `"Hazardous Materials Removal Workers"', add
label define occ2010_lbl 6730 `"Highway Maintenance Workers"', add
label define occ2010_lbl 6740 `"Rail-Track Laying and Maintenance Equipment Operators"', add
label define occ2010_lbl 6765 `"Construction workers, nec"', add
label define occ2010_lbl 6800 `"Derrick, rotary drill, and service unit operators, and roustabouts, oil, gas, and mining"', add
label define occ2010_lbl 6820 `"Earth Drillers, Except Oil and Gas"', add
label define occ2010_lbl 6830 `"Explosives Workers, Ordnance Handling Experts, and Blasters"', add
label define occ2010_lbl 6840 `"Mining Machine Operators"', add
label define occ2010_lbl 6940 `"Extraction workers, nec"', add
label define occ2010_lbl 7000 `"First-Line Supervisors of Mechanics, Installers, and Repairers"', add
label define occ2010_lbl 7010 `"Computer, Automated Teller, and Office Machine Repairers"', add
label define occ2010_lbl 7020 `"Radio and Telecommunications Equipment Installers and Repairers"', add
label define occ2010_lbl 7030 `"Avionics Technicians"', add
label define occ2010_lbl 7040 `"Electric Motor, Power Tool, and Related Repairers"', add
label define occ2010_lbl 7100 `"Electrical and electronics repairers, transportation equipment, and industrial and utility"', add
label define occ2010_lbl 7110 `"Electronic Equipment Installers and Repairers, Motor Vehicles"', add
label define occ2010_lbl 7120 `"Electronic Home Entertainment Equipment Installers and Repairers"', add
label define occ2010_lbl 7125 `"Electronic Repairs, nec"', add
label define occ2010_lbl 7130 `"Security and Fire Alarm Systems Installers"', add
label define occ2010_lbl 7140 `"Aircraft Mechanics and Service Technicians"', add
label define occ2010_lbl 7150 `"Automotive Body and Related Repairers"', add
label define occ2010_lbl 7160 `"Automotive Glass Installers and Repairers"', add
label define occ2010_lbl 7200 `"Automotive Service Technicians and Mechanics"', add
label define occ2010_lbl 7210 `"Bus and Truck Mechanics and Diesel Engine Specialists"', add
label define occ2010_lbl 7220 `"Heavy Vehicle and Mobile Equipment Service Technicians and Mechanics"', add
label define occ2010_lbl 7240 `"Small Engine Mechanics"', add
label define occ2010_lbl 7260 `"Vehicle and Mobile Equipment Mechanics, Installers, and Repairers, nec"', add
label define occ2010_lbl 7300 `"Control and Valve Installers and Repairers"', add
label define occ2010_lbl 7315 `"Heating, Air Conditioning, and Refrigeration Mechanics and Installers"', add
label define occ2010_lbl 7320 `"Home Appliance Repairers"', add
label define occ2010_lbl 7330 `"Industrial and Refractory Machinery Mechanics"', add
label define occ2010_lbl 7340 `"Maintenance and Repair Workers, General"', add
label define occ2010_lbl 7350 `"Maintenance Workers, Machinery"', add
label define occ2010_lbl 7360 `"Millwrights"', add
label define occ2010_lbl 7410 `"Electrical Power-Line Installers and Repairers"', add
label define occ2010_lbl 7420 `"Telecommunications Line Installers and Repairers"', add
label define occ2010_lbl 7430 `"Precision Instrument and Equipment Repairers"', add
label define occ2010_lbl 7510 `"Coin, Vending, and Amusement Machine Servicers and Repairers"', add
label define occ2010_lbl 7540 `"Locksmiths and Safe Repairers"', add
label define occ2010_lbl 7550 `"Manufactured Building and Mobile Home Installers"', add
label define occ2010_lbl 7560 `"Riggers"', add
label define occ2010_lbl 7610 `"Helpers--Installation, Maintenance, and Repair Workers"', add
label define occ2010_lbl 7630 `"Other Installation, Maintenance, and Repair Workers Including Wind Turbine Service Technicians, and Commercial Divers, and Signal and Track Switch Repairers"', add
label define occ2010_lbl 7700 `"First-Line Supervisors of Production and Operating Workers"', add
label define occ2010_lbl 7710 `"Aircraft Structure, Surfaces, Rigging, and Systems Assemblers"', add
label define occ2010_lbl 7720 `"Electrical, Electronics, and Electromechanical Assemblers"', add
label define occ2010_lbl 7730 `"Engine and Other Machine Assemblers"', add
label define occ2010_lbl 7740 `"Structural Metal Fabricators and Fitters"', add
label define occ2010_lbl 7750 `"Assemblers and Fabricators, nec"', add
label define occ2010_lbl 7800 `"Bakers"', add
label define occ2010_lbl 7810 `"Butchers and Other Meat, Poultry, and Fish Processing Workers"', add
label define occ2010_lbl 7830 `"Food and Tobacco Roasting, Baking, and Drying Machine Operators and Tenders"', add
label define occ2010_lbl 7840 `"Food Batchmakers"', add
label define occ2010_lbl 7850 `"Food Cooking Machine Operators and Tenders"', add
label define occ2010_lbl 7855 `"Food Processing, nec"', add
label define occ2010_lbl 7900 `"Computer Control Programmers and Operators"', add
label define occ2010_lbl 7920 `"Extruding and Drawing Machine Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 7930 `"Forging Machine Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 7940 `"Rolling Machine Setters, Operators, and Tenders, metal and Plastic"', add
label define occ2010_lbl 7950 `"Cutting, Punching, and Press Machine Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 7960 `"Drilling and Boring Machine Tool Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 8000 `"Grinding, Lapping, Polishing, and Buffing Machine Tool Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 8010 `"Lathe and Turning Machine Tool Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 8030 `"Machinists"', add
label define occ2010_lbl 8040 `"Metal Furnace Operators, Tenders, Pourers, and Casters"', add
label define occ2010_lbl 8060 `"Model Makers and Patternmakers, Metal and Plastic"', add
label define occ2010_lbl 8100 `"Molders and Molding Machine Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 8130 `"Tool and Die Makers"', add
label define occ2010_lbl 8140 `"Welding, Soldering, and Brazing Workers"', add
label define occ2010_lbl 8150 `"Heat Treating Equipment Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 8200 `"Plating and Coating Machine Setters, Operators, and Tenders, Metal and Plastic"', add
label define occ2010_lbl 8210 `"Tool Grinders, Filers, and Sharpeners"', add
label define occ2010_lbl 8220 `"Metal workers and plastic workers, nec"', add
label define occ2010_lbl 8230 `"Bookbinders, Printing Machine Operators, and Job Printers"', add
label define occ2010_lbl 8250 `"Prepress Technicians and Workers"', add
label define occ2010_lbl 8300 `"Laundry and Dry-Cleaning Workers"', add
label define occ2010_lbl 8310 `"Pressers, Textile, Garment, and Related Materials"', add
label define occ2010_lbl 8320 `"Sewing Machine Operators"', add
label define occ2010_lbl 8330 `"Shoe and Leather Workers and Repairers"', add
label define occ2010_lbl 8340 `"Shoe Machine Operators and Tenders"', add
label define occ2010_lbl 8350 `"Tailors, Dressmakers, and Sewers"', add
label define occ2010_lbl 8400 `"Textile bleaching and dyeing, and cutting machine setters, operators, and tenders"', add
label define occ2010_lbl 8410 `"Textile Knitting and Weaving Machine Setters, Operators, and Tenders"', add
label define occ2010_lbl 8420 `"Textile Winding, Twisting, and Drawing Out Machine Setters, Operators, and Tenders"', add
label define occ2010_lbl 8450 `"Upholsterers"', add
label define occ2010_lbl 8460 `"Textile, Apparel, and Furnishings workers, nec"', add
label define occ2010_lbl 8500 `"Cabinetmakers and Bench Carpenters"', add
label define occ2010_lbl 8510 `"Furniture Finishers"', add
label define occ2010_lbl 8530 `"Sawing Machine Setters, Operators, and Tenders, Wood"', add
label define occ2010_lbl 8540 `"Woodworking Machine Setters, Operators, and Tenders, Except Sawing"', add
label define occ2010_lbl 8550 `"Woodworkers including model makers and patternmakers, nec"', add
label define occ2010_lbl 8600 `"Power Plant Operators, Distributors, and Dispatchers"', add
label define occ2010_lbl 8610 `"Stationary Engineers and Boiler Operators"', add
label define occ2010_lbl 8620 `"Water Wastewater Treatment Plant and System Operators"', add
label define occ2010_lbl 8630 `"Plant and System Operators, nec"', add
label define occ2010_lbl 8640 `"Chemical Processing Machine Setters, Operators, and Tenders"', add
label define occ2010_lbl 8650 `"Crushing, Grinding, Polishing, Mixing, and Blending Workers"', add
label define occ2010_lbl 8710 `"Cutting Workers"', add
label define occ2010_lbl 8720 `"Extruding, Forming, Pressing, and Compacting Machine Setters, Operators, and Tenders"', add
label define occ2010_lbl 8730 `"Furnace, Kiln, Oven, Drier, and Kettle Operators and Tenders"', add
label define occ2010_lbl 8740 `"Inspectors, Testers, Sorters, Samplers, and Weighers"', add
label define occ2010_lbl 8750 `"Jewelers and Precious Stone and Metal Workers"', add
label define occ2010_lbl 8760 `"Medical, Dental, and Ophthalmic Laboratory Technicians"', add
label define occ2010_lbl 8800 `"Packaging and Filling Machine Operators and Tenders"', add
label define occ2010_lbl 8810 `"Painting Workers and Dyers"', add
label define occ2010_lbl 8830 `"Photographic Process Workers and Processing Machine Operators"', add
label define occ2010_lbl 8850 `"Adhesive Bonding Machine Operators and Tenders"', add
label define occ2010_lbl 8860 `"Cleaning, Washing, and Metal Pickling Equipment Operators and Tenders"', add
label define occ2010_lbl 8910 `"Etchers, Engravers, and Lithographers"', add
label define occ2010_lbl 8920 `"Molders, Shapers, and Casters, Except Metal and Plastic"', add
label define occ2010_lbl 8930 `"Paper Goods Machine Setters, Operators, and Tenders"', add
label define occ2010_lbl 8940 `"Tire Builders"', add
label define occ2010_lbl 8950 `"Helpers--Production Workers"', add
label define occ2010_lbl 8965 `"Other production workers including semiconductor processors and cooling and freezing equipment operators"', add
label define occ2010_lbl 9000 `"Supervisors of Transportation and Material Moving Workers"', add
label define occ2010_lbl 9030 `"Aircraft Pilots and Flight Engineers"', add
label define occ2010_lbl 9040 `"Air Traffic Controllers and Airfield Operations Specialists"', add
label define occ2010_lbl 9050 `"Flight Attendants and Transportation Workers and Attendants"', add
label define occ2010_lbl 9100 `"Bus and Ambulance Drivers and Attendants"', add
label define occ2010_lbl 9130 `"Driver/Sales Workers and Truck Drivers"', add
label define occ2010_lbl 9140 `"Taxi Drivers and Chauffeurs"', add
label define occ2010_lbl 9150 `"Motor Vehicle Operators, All Other"', add
label define occ2010_lbl 9200 `"Locomotive Engineers and Operators"', add
label define occ2010_lbl 9230 `"Railroad Brake, Signal, and Switch Operators"', add
label define occ2010_lbl 9240 `"Railroad Conductors and Yardmasters"', add
label define occ2010_lbl 9260 `"Subway, Streetcar, and Other Rail Transportation Workers"', add
label define occ2010_lbl 9300 `"Sailors and marine oilers, and ship engineers"', add
label define occ2010_lbl 9310 `"Ship and Boat Captains and Operators"', add
label define occ2010_lbl 9350 `"Parking Lot Attendants"', add
label define occ2010_lbl 9360 `"Automotive and Watercraft Service Attendants"', add
label define occ2010_lbl 9410 `"Transportation Inspectors"', add
label define occ2010_lbl 9420 `"Transportation workers, nec"', add
label define occ2010_lbl 9510 `"Crane and Tower Operators"', add
label define occ2010_lbl 9520 `"Dredge, Excavating, and Loading Machine Operators"', add
label define occ2010_lbl 9560 `"Conveyor operators and tenders, and hoist and winch operators"', add
label define occ2010_lbl 9600 `"Industrial Truck and Tractor Operators"', add
label define occ2010_lbl 9610 `"Cleaners of Vehicles and Equipment"', add
label define occ2010_lbl 9620 `"Laborers and Freight, Stock, and Material Movers, Hand"', add
label define occ2010_lbl 9630 `"Machine Feeders and Offbearers"', add
label define occ2010_lbl 9640 `"Packers and Packagers, Hand"', add
label define occ2010_lbl 9650 `"Pumping Station Operators"', add
label define occ2010_lbl 9720 `"Refuse and Recyclable Material Collectors"', add
label define occ2010_lbl 9750 `"Material moving workers, nec"', add
label define occ2010_lbl 9800 `"Military Officer Special and Tactical Operations Leaders"', add
label define occ2010_lbl 9810 `"First-Line Enlisted Military Supervisors"', add
label define occ2010_lbl 9820 `"Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members"', add
label define occ2010_lbl 9830 `"Military, Rank Not Specified"', add
label define occ2010_lbl 9920 `"Unemployed, with No Work Experience in the Last 5 Years or Earlier or Never Worked"', add
label values occ2010 occ2010_lbl

label define ind_lbl 0000 `"0000"'
label define ind_lbl 0001 `"0001"', add
label define ind_lbl 0002 `"0002"', add
label define ind_lbl 0003 `"0003"', add
label define ind_lbl 0004 `"0004"', add
label define ind_lbl 0005 `"0005"', add
label define ind_lbl 0006 `"0006"', add
label define ind_lbl 0007 `"0007"', add
label define ind_lbl 0008 `"0008"', add
label define ind_lbl 0009 `"0009"', add
label define ind_lbl 0010 `"0010"', add
label define ind_lbl 0011 `"0011"', add
label define ind_lbl 0012 `"0012"', add
label define ind_lbl 0013 `"0013"', add
label define ind_lbl 0014 `"0014"', add
label define ind_lbl 0015 `"0015"', add
label define ind_lbl 0016 `"0016"', add
label define ind_lbl 0017 `"0017"', add
label define ind_lbl 0018 `"0018"', add
label define ind_lbl 0019 `"0019"', add
label define ind_lbl 0020 `"0020"', add
label define ind_lbl 0021 `"0021"', add
label define ind_lbl 0022 `"0022"', add
label define ind_lbl 0023 `"0023"', add
label define ind_lbl 0024 `"0024"', add
label define ind_lbl 0025 `"0025"', add
label define ind_lbl 0026 `"0026"', add
label define ind_lbl 0027 `"0027"', add
label define ind_lbl 0028 `"0028"', add
label define ind_lbl 0029 `"0029"', add
label define ind_lbl 0030 `"0030"', add
label define ind_lbl 0031 `"0031"', add
label define ind_lbl 0032 `"0032"', add
label define ind_lbl 0033 `"0033"', add
label define ind_lbl 0034 `"0034"', add
label define ind_lbl 0035 `"0035"', add
label define ind_lbl 0036 `"0036"', add
label define ind_lbl 0037 `"0037"', add
label define ind_lbl 0038 `"0038"', add
label define ind_lbl 0039 `"0039"', add
label define ind_lbl 0040 `"0040"', add
label define ind_lbl 0041 `"0041"', add
label define ind_lbl 0042 `"0042"', add
label define ind_lbl 0043 `"0043"', add
label define ind_lbl 0044 `"0044"', add
label define ind_lbl 0045 `"0045"', add
label define ind_lbl 0046 `"0046"', add
label define ind_lbl 0047 `"0047"', add
label define ind_lbl 0048 `"0048"', add
label define ind_lbl 0049 `"0049"', add
label define ind_lbl 0050 `"0050"', add
label define ind_lbl 0051 `"0051"', add
label define ind_lbl 0052 `"0052"', add
label define ind_lbl 0053 `"0053"', add
label define ind_lbl 0054 `"0054"', add
label define ind_lbl 0055 `"0055"', add
label define ind_lbl 0056 `"0056"', add
label define ind_lbl 0057 `"0057"', add
label define ind_lbl 0058 `"0058"', add
label define ind_lbl 0059 `"0059"', add
label define ind_lbl 0060 `"0060"', add
label define ind_lbl 0061 `"0061"', add
label define ind_lbl 0062 `"0062"', add
label define ind_lbl 0063 `"0063"', add
label define ind_lbl 0064 `"0064"', add
label define ind_lbl 0065 `"0065"', add
label define ind_lbl 0066 `"0066"', add
label define ind_lbl 0067 `"0067"', add
label define ind_lbl 0068 `"0068"', add
label define ind_lbl 0069 `"0069"', add
label define ind_lbl 0070 `"0070"', add
label define ind_lbl 0071 `"0071"', add
label define ind_lbl 0072 `"0072"', add
label define ind_lbl 0073 `"0073"', add
label define ind_lbl 0074 `"0074"', add
label define ind_lbl 0075 `"0075"', add
label define ind_lbl 0076 `"0076"', add
label define ind_lbl 0077 `"0077"', add
label define ind_lbl 0078 `"0078"', add
label define ind_lbl 0079 `"0079"', add
label define ind_lbl 0080 `"0080"', add
label define ind_lbl 0081 `"0081"', add
label define ind_lbl 0082 `"0082"', add
label define ind_lbl 0083 `"0083"', add
label define ind_lbl 0084 `"0084"', add
label define ind_lbl 0085 `"0085"', add
label define ind_lbl 0086 `"0086"', add
label define ind_lbl 0087 `"0087"', add
label define ind_lbl 0088 `"0088"', add
label define ind_lbl 0089 `"0089"', add
label define ind_lbl 0090 `"0090"', add
label define ind_lbl 0091 `"0091"', add
label define ind_lbl 0092 `"0092"', add
label define ind_lbl 0093 `"0093"', add
label define ind_lbl 0094 `"0094"', add
label define ind_lbl 0095 `"0095"', add
label define ind_lbl 0096 `"0096"', add
label define ind_lbl 0097 `"0097"', add
label define ind_lbl 0098 `"0098"', add
label define ind_lbl 0099 `"0099"', add
label define ind_lbl 0100 `"0100"', add
label define ind_lbl 0101 `"0101"', add
label define ind_lbl 0102 `"0102"', add
label define ind_lbl 0103 `"0103"', add
label define ind_lbl 0104 `"0104"', add
label define ind_lbl 0105 `"0105"', add
label define ind_lbl 0106 `"0106"', add
label define ind_lbl 0107 `"0107"', add
label define ind_lbl 0108 `"0108"', add
label define ind_lbl 0109 `"0109"', add
label define ind_lbl 0110 `"0110"', add
label define ind_lbl 0111 `"0111"', add
label define ind_lbl 0112 `"0112"', add
label define ind_lbl 0113 `"0113"', add
label define ind_lbl 0114 `"0114"', add
label define ind_lbl 0115 `"0115"', add
label define ind_lbl 0116 `"0116"', add
label define ind_lbl 0117 `"0117"', add
label define ind_lbl 0118 `"0118"', add
label define ind_lbl 0119 `"0119"', add
label define ind_lbl 0120 `"0120"', add
label define ind_lbl 0121 `"0121"', add
label define ind_lbl 0122 `"0122"', add
label define ind_lbl 0123 `"0123"', add
label define ind_lbl 0124 `"0124"', add
label define ind_lbl 0125 `"0125"', add
label define ind_lbl 0126 `"0126"', add
label define ind_lbl 0127 `"0127"', add
label define ind_lbl 0128 `"0128"', add
label define ind_lbl 0129 `"0129"', add
label define ind_lbl 0130 `"0130"', add
label define ind_lbl 0131 `"0131"', add
label define ind_lbl 0137 `"0137"', add
label define ind_lbl 0138 `"0138"', add
label define ind_lbl 0139 `"0139"', add
label define ind_lbl 0146 `"0146"', add
label define ind_lbl 0147 `"0147"', add
label define ind_lbl 0148 `"0148"', add
label define ind_lbl 0149 `"0149"', add
label define ind_lbl 0157 `"0157"', add
label define ind_lbl 0158 `"0158"', add
label define ind_lbl 0159 `"0159"', add
label define ind_lbl 0166 `"0166"', add
label define ind_lbl 0167 `"0167"', add
label define ind_lbl 0168 `"0168"', add
label define ind_lbl 0169 `"0169"', add
label define ind_lbl 0176 `"0176"', add
label define ind_lbl 0177 `"0177"', add
label define ind_lbl 0178 `"0178"', add
label define ind_lbl 0179 `"0179"', add
label define ind_lbl 0186 `"0186"', add
label define ind_lbl 0187 `"0187"', add
label define ind_lbl 0188 `"0188"', add
label define ind_lbl 0197 `"0197"', add
label define ind_lbl 0198 `"0198"', add
label define ind_lbl 0199 `"0199"', add
label define ind_lbl 0206 `"0206"', add
label define ind_lbl 0207 `"0207"', add
label define ind_lbl 0208 `"0208"', add
label define ind_lbl 0209 `"0209"', add
label define ind_lbl 0219 `"0219"', add
label define ind_lbl 0227 `"0227"', add
label define ind_lbl 0228 `"0228"', add
label define ind_lbl 0229 `"0229"', add
label define ind_lbl 0236 `"0236"', add
label define ind_lbl 0237 `"0237"', add
label define ind_lbl 0238 `"0238"', add
label define ind_lbl 0239 `"0239"', add
label define ind_lbl 0246 `"0246"', add
label define ind_lbl 0247 `"0247"', add
label define ind_lbl 0248 `"0248"', add
label define ind_lbl 0249 `"0249"', add
label define ind_lbl 0257 `"0257"', add
label define ind_lbl 0258 `"0258"', add
label define ind_lbl 0259 `"0259"', add
label define ind_lbl 0267 `"0267"', add
label define ind_lbl 0268 `"0268"', add
label define ind_lbl 0269 `"0269"', add
label define ind_lbl 0278 `"0278"', add
label define ind_lbl 0279 `"0279"', add
label define ind_lbl 0287 `"0287"', add
label define ind_lbl 0288 `"0288"', add
label define ind_lbl 0289 `"0289"', add
label define ind_lbl 0293 `"0293"', add
label define ind_lbl 0297 `"0297"', add
label define ind_lbl 0298 `"0298"', add
label define ind_lbl 0299 `"0299"', add
label define ind_lbl 0307 `"0307"', add
label define ind_lbl 0308 `"0308"', add
label define ind_lbl 0309 `"0309"', add
label define ind_lbl 0317 `"0317"', add
label define ind_lbl 0318 `"0318"', add
label define ind_lbl 0319 `"0319"', add
label define ind_lbl 0327 `"0327"', add
label define ind_lbl 0328 `"0328"', add
label define ind_lbl 0329 `"0329"', add
label define ind_lbl 0337 `"0337"', add
label define ind_lbl 0338 `"0338"', add
label define ind_lbl 0339 `"0339"', add
label define ind_lbl 0346 `"0346"', add
label define ind_lbl 0347 `"0347"', add
label define ind_lbl 0348 `"0348"', add
label define ind_lbl 0349 `"0349"', add
label define ind_lbl 0357 `"0357"', add
label define ind_lbl 0358 `"0358"', add
label define ind_lbl 0359 `"0359"', add
label define ind_lbl 0367 `"0367"', add
label define ind_lbl 0368 `"0368"', add
label define ind_lbl 0369 `"0369"', add
label define ind_lbl 0377 `"0377"', add
label define ind_lbl 0378 `"0378"', add
label define ind_lbl 0379 `"0379"', add
label define ind_lbl 0387 `"0387"', add
label define ind_lbl 0388 `"0388"', add
label define ind_lbl 0389 `"0389"', add
label define ind_lbl 0397 `"0397"', add
label define ind_lbl 0398 `"0398"', add
label define ind_lbl 0399 `"0399"', add
label define ind_lbl 0407 `"0407"', add
label define ind_lbl 0408 `"0408"', add
label define ind_lbl 0409 `"0409"', add
label define ind_lbl 0417 `"0417"', add
label define ind_lbl 0418 `"0418"', add
label define ind_lbl 0419 `"0419"', add
label define ind_lbl 0427 `"0427"', add
label define ind_lbl 0428 `"0428"', add
label define ind_lbl 0429 `"0429"', add
label define ind_lbl 0447 `"0447"', add
label define ind_lbl 0448 `"0448"', add
label define ind_lbl 0449 `"0449"', add
label define ind_lbl 0467 `"0467"', add
label define ind_lbl 0468 `"0468"', add
label define ind_lbl 0469 `"0469"', add
label define ind_lbl 0477 `"0477"', add
label define ind_lbl 0478 `"0478"', add
label define ind_lbl 0479 `"0479"', add
label define ind_lbl 0499 `"0499"', add
label define ind_lbl 0507 `"0507"', add
label define ind_lbl 0508 `"0508"', add
label define ind_lbl 0509 `"0509"', add
label define ind_lbl 0527 `"0527"', add
label define ind_lbl 0528 `"0528"', add
label define ind_lbl 0529 `"0529"', add
label define ind_lbl 0536 `"0536"', add
label define ind_lbl 0537 `"0537"', add
label define ind_lbl 0538 `"0538"', add
label define ind_lbl 0539 `"0539"', add
label define ind_lbl 0557 `"0557"', add
label define ind_lbl 0558 `"0558"', add
label define ind_lbl 0559 `"0559"', add
label define ind_lbl 0566 `"0566"', add
label define ind_lbl 0567 `"0567"', add
label define ind_lbl 0568 `"0568"', add
label define ind_lbl 0569 `"0569"', add
label define ind_lbl 0587 `"0587"', add
label define ind_lbl 0588 `"0588"', add
label define ind_lbl 0599 `"0599"', add
label define ind_lbl 0607 `"0607"', add
label define ind_lbl 0608 `"0608"', add
label define ind_lbl 0609 `"0609"', add
label define ind_lbl 0617 `"0617"', add
label define ind_lbl 0618 `"0618"', add
label define ind_lbl 0619 `"0619"', add
label define ind_lbl 0626 `"0626"', add
label define ind_lbl 0627 `"0627"', add
label define ind_lbl 0628 `"0628"', add
label define ind_lbl 0629 `"0629"', add
label define ind_lbl 0636 `"0636"', add
label define ind_lbl 0637 `"0637"', add
label define ind_lbl 0638 `"0638"', add
label define ind_lbl 0639 `"0639"', add
label define ind_lbl 0646 `"0646"', add
label define ind_lbl 0647 `"0647"', add
label define ind_lbl 0648 `"0648"', add
label define ind_lbl 0649 `"0649"', add
label define ind_lbl 0657 `"0657"', add
label define ind_lbl 0658 `"0658"', add
label define ind_lbl 0667 `"0667"', add
label define ind_lbl 0668 `"0668"', add
label define ind_lbl 0669 `"0669"', add
label define ind_lbl 0676 `"0676"', add
label define ind_lbl 0677 `"0677"', add
label define ind_lbl 0678 `"0678"', add
label define ind_lbl 0679 `"0679"', add
label define ind_lbl 0687 `"0687"', add
label define ind_lbl 0688 `"0688"', add
label define ind_lbl 0689 `"0689"', add
label define ind_lbl 0696 `"0696"', add
label define ind_lbl 0697 `"0697"', add
label define ind_lbl 0698 `"0698"', add
label define ind_lbl 0699 `"0699"', add
label define ind_lbl 0706 `"0706"', add
label define ind_lbl 0707 `"0707"', add
label define ind_lbl 0708 `"0708"', add
label define ind_lbl 0709 `"0709"', add
label define ind_lbl 0717 `"0717"', add
label define ind_lbl 0718 `"0718"', add
label define ind_lbl 0719 `"0719"', add
label define ind_lbl 0727 `"0727"', add
label define ind_lbl 0728 `"0728"', add
label define ind_lbl 0729 `"0729"', add
label define ind_lbl 0736 `"0736"', add
label define ind_lbl 0737 `"0737"', add
label define ind_lbl 0738 `"0738"', add
label define ind_lbl 0739 `"0739"', add
label define ind_lbl 0747 `"0747"', add
label define ind_lbl 0748 `"0748"', add
label define ind_lbl 0749 `"0749"', add
label define ind_lbl 0756 `"0756"', add
label define ind_lbl 0757 `"0757"', add
label define ind_lbl 0758 `"0758"', add
label define ind_lbl 0759 `"0759"', add
label define ind_lbl 0766 `"0766"', add
label define ind_lbl 0767 `"0767"', add
label define ind_lbl 0769 `"0769"', add
label define ind_lbl 0776 `"0776"', add
label define ind_lbl 0777 `"0777"', add
label define ind_lbl 0778 `"0778"', add
label define ind_lbl 0779 `"0779"', add
label define ind_lbl 0786 `"0786"', add
label define ind_lbl 0787 `"0787"', add
label define ind_lbl 0788 `"0788"', add
label define ind_lbl 0789 `"0789"', add
label define ind_lbl 0797 `"0797"', add
label define ind_lbl 0798 `"0798"', add
label define ind_lbl 0799 `"0799"', add
label define ind_lbl 0807 `"0807"', add
label define ind_lbl 0808 `"0808"', add
label define ind_lbl 0809 `"0809"', add
label define ind_lbl 0817 `"0817"', add
label define ind_lbl 0826 `"0826"', add
label define ind_lbl 0828 `"0828"', add
label define ind_lbl 0829 `"0829"', add
label define ind_lbl 0837 `"0837"', add
label define ind_lbl 0838 `"0838"', add
label define ind_lbl 0839 `"0839"', add
label define ind_lbl 0847 `"0847"', add
label define ind_lbl 0848 `"0848"', add
label define ind_lbl 0849 `"0849"', add
label define ind_lbl 0856 `"0856"', add
label define ind_lbl 0857 `"0857"', add
label define ind_lbl 0858 `"0858"', add
label define ind_lbl 0859 `"0859"', add
label define ind_lbl 0867 `"0867"', add
label define ind_lbl 0868 `"0868"', add
label define ind_lbl 0869 `"0869"', add
label define ind_lbl 0876 `"0876"', add
label define ind_lbl 0877 `"0877"', add
label define ind_lbl 0878 `"0878"', add
label define ind_lbl 0879 `"0879"', add
label define ind_lbl 0887 `"0887"', add
label define ind_lbl 0888 `"0888"', add
label define ind_lbl 0889 `"0889"', add
label define ind_lbl 0897 `"0897"', add
label define ind_lbl 0899 `"0899"', add
label define ind_lbl 0907 `"0907"', add
label define ind_lbl 0917 `"0917"', add
label define ind_lbl 0927 `"0927"', add
label define ind_lbl 0937 `"0937"', add
label define ind_lbl 0947 `"0947"', add
label define ind_lbl 0995 `"0995"', add
label define ind_lbl 0996 `"0996"', add
label define ind_lbl 0997 `"0997"', add
label define ind_lbl 0998 `"0998"', add
label define ind_lbl 0999 `"0999"', add
label values ind ind_lbl

label define wkswork2_lbl 0 `"N/A"'
label define wkswork2_lbl 1 `"1-13 weeks"', add
label define wkswork2_lbl 2 `"14-26 weeks"', add
label define wkswork2_lbl 3 `"27-39 weeks"', add
label define wkswork2_lbl 4 `"40-47 weeks"', add
label define wkswork2_lbl 5 `"48-49 weeks"', add
label define wkswork2_lbl 6 `"50-52 weeks"', add
label values wkswork2 wkswork2_lbl

label define uhrswork_lbl 00 `"N/A"'
label define uhrswork_lbl 01 `"1"', add
label define uhrswork_lbl 02 `"2"', add
label define uhrswork_lbl 03 `"3"', add
label define uhrswork_lbl 04 `"4"', add
label define uhrswork_lbl 05 `"5"', add
label define uhrswork_lbl 06 `"6"', add
label define uhrswork_lbl 07 `"7"', add
label define uhrswork_lbl 08 `"8"', add
label define uhrswork_lbl 09 `"9"', add
label define uhrswork_lbl 10 `"10"', add
label define uhrswork_lbl 11 `"11"', add
label define uhrswork_lbl 12 `"12"', add
label define uhrswork_lbl 13 `"13"', add
label define uhrswork_lbl 14 `"14"', add
label define uhrswork_lbl 15 `"15"', add
label define uhrswork_lbl 16 `"16"', add
label define uhrswork_lbl 17 `"17"', add
label define uhrswork_lbl 18 `"18"', add
label define uhrswork_lbl 19 `"19"', add
label define uhrswork_lbl 20 `"20"', add
label define uhrswork_lbl 21 `"21"', add
label define uhrswork_lbl 22 `"22"', add
label define uhrswork_lbl 23 `"23"', add
label define uhrswork_lbl 24 `"24"', add
label define uhrswork_lbl 25 `"25"', add
label define uhrswork_lbl 26 `"26"', add
label define uhrswork_lbl 27 `"27"', add
label define uhrswork_lbl 28 `"28"', add
label define uhrswork_lbl 29 `"29"', add
label define uhrswork_lbl 30 `"30"', add
label define uhrswork_lbl 31 `"31"', add
label define uhrswork_lbl 32 `"32"', add
label define uhrswork_lbl 33 `"33"', add
label define uhrswork_lbl 34 `"34"', add
label define uhrswork_lbl 35 `"35"', add
label define uhrswork_lbl 36 `"36"', add
label define uhrswork_lbl 37 `"37"', add
label define uhrswork_lbl 38 `"38"', add
label define uhrswork_lbl 39 `"39"', add
label define uhrswork_lbl 40 `"40"', add
label define uhrswork_lbl 41 `"41"', add
label define uhrswork_lbl 42 `"42"', add
label define uhrswork_lbl 43 `"43"', add
label define uhrswork_lbl 44 `"44"', add
label define uhrswork_lbl 45 `"45"', add
label define uhrswork_lbl 46 `"46"', add
label define uhrswork_lbl 47 `"47"', add
label define uhrswork_lbl 48 `"48"', add
label define uhrswork_lbl 49 `"49"', add
label define uhrswork_lbl 50 `"50"', add
label define uhrswork_lbl 51 `"51"', add
label define uhrswork_lbl 52 `"52"', add
label define uhrswork_lbl 53 `"53"', add
label define uhrswork_lbl 54 `"54"', add
label define uhrswork_lbl 55 `"55"', add
label define uhrswork_lbl 56 `"56"', add
label define uhrswork_lbl 57 `"57"', add
label define uhrswork_lbl 58 `"58"', add
label define uhrswork_lbl 59 `"59"', add
label define uhrswork_lbl 60 `"60"', add
label define uhrswork_lbl 61 `"61"', add
label define uhrswork_lbl 62 `"62"', add
label define uhrswork_lbl 63 `"63"', add
label define uhrswork_lbl 64 `"64"', add
label define uhrswork_lbl 65 `"65"', add
label define uhrswork_lbl 66 `"66"', add
label define uhrswork_lbl 67 `"67"', add
label define uhrswork_lbl 68 `"68"', add
label define uhrswork_lbl 69 `"69"', add
label define uhrswork_lbl 70 `"70"', add
label define uhrswork_lbl 71 `"71"', add
label define uhrswork_lbl 72 `"72"', add
label define uhrswork_lbl 73 `"73"', add
label define uhrswork_lbl 74 `"74"', add
label define uhrswork_lbl 75 `"75"', add
label define uhrswork_lbl 76 `"76"', add
label define uhrswork_lbl 77 `"77"', add
label define uhrswork_lbl 78 `"78"', add
label define uhrswork_lbl 79 `"79"', add
label define uhrswork_lbl 80 `"80"', add
label define uhrswork_lbl 81 `"81"', add
label define uhrswork_lbl 82 `"82"', add
label define uhrswork_lbl 83 `"83"', add
label define uhrswork_lbl 84 `"84"', add
label define uhrswork_lbl 85 `"85"', add
label define uhrswork_lbl 86 `"86"', add
label define uhrswork_lbl 87 `"87"', add
label define uhrswork_lbl 88 `"88"', add
label define uhrswork_lbl 89 `"89"', add
label define uhrswork_lbl 90 `"90"', add
label define uhrswork_lbl 91 `"91"', add
label define uhrswork_lbl 92 `"92"', add
label define uhrswork_lbl 93 `"93"', add
label define uhrswork_lbl 94 `"94"', add
label define uhrswork_lbl 95 `"95"', add
label define uhrswork_lbl 96 `"96"', add
label define uhrswork_lbl 97 `"97"', add
label define uhrswork_lbl 98 `"98"', add
label define uhrswork_lbl 99 `"99 (Topcode)"', add
label values uhrswork uhrswork_lbl

label define incwage_lbl 000000 `"000000"'
label define incwage_lbl 000100 `"000100"', add
label define incwage_lbl 000200 `"000200"', add
label define incwage_lbl 000300 `"000300"', add
label define incwage_lbl 000400 `"000400"', add
label define incwage_lbl 000500 `"000500"', add
label define incwage_lbl 000600 `"000600"', add
label define incwage_lbl 000700 `"000700"', add
label define incwage_lbl 000800 `"000800"', add
label define incwage_lbl 000900 `"000900"', add
label define incwage_lbl 001000 `"001000"', add
label define incwage_lbl 001100 `"001100"', add
label define incwage_lbl 001200 `"001200"', add
label define incwage_lbl 001300 `"001300"', add
label define incwage_lbl 001400 `"001400"', add
label define incwage_lbl 001500 `"001500"', add
label define incwage_lbl 001600 `"001600"', add
label define incwage_lbl 001700 `"001700"', add
label define incwage_lbl 001800 `"001800"', add
label define incwage_lbl 001900 `"001900"', add
label define incwage_lbl 002000 `"002000"', add
label define incwage_lbl 002100 `"002100"', add
label define incwage_lbl 002200 `"002200"', add
label define incwage_lbl 002300 `"002300"', add
label define incwage_lbl 002400 `"002400"', add
label define incwage_lbl 002500 `"002500"', add
label define incwage_lbl 002600 `"002600"', add
label define incwage_lbl 002700 `"002700"', add
label define incwage_lbl 002800 `"002800"', add
label define incwage_lbl 002900 `"002900"', add
label define incwage_lbl 003000 `"003000"', add
label define incwage_lbl 003100 `"003100"', add
label define incwage_lbl 003200 `"003200"', add
label define incwage_lbl 003300 `"003300"', add
label define incwage_lbl 003400 `"003400"', add
label define incwage_lbl 003500 `"003500"', add
label define incwage_lbl 003600 `"003600"', add
label define incwage_lbl 003700 `"003700"', add
label define incwage_lbl 003800 `"003800"', add
label define incwage_lbl 003900 `"003900"', add
label define incwage_lbl 004000 `"004000"', add
label define incwage_lbl 004100 `"004100"', add
label define incwage_lbl 004200 `"004200"', add
label define incwage_lbl 004300 `"004300"', add
label define incwage_lbl 004400 `"004400"', add
label define incwage_lbl 004500 `"004500"', add
label define incwage_lbl 004600 `"004600"', add
label define incwage_lbl 004700 `"004700"', add
label define incwage_lbl 004800 `"004800"', add
label define incwage_lbl 004900 `"004900"', add
label define incwage_lbl 005000 `"005000"', add
label define incwage_lbl 005100 `"005100"', add
label define incwage_lbl 005200 `"005200"', add
label define incwage_lbl 005300 `"005300"', add
label define incwage_lbl 005400 `"005400"', add
label define incwage_lbl 005500 `"005500"', add
label define incwage_lbl 005600 `"005600"', add
label define incwage_lbl 005700 `"005700"', add
label define incwage_lbl 005800 `"005800"', add
label define incwage_lbl 005900 `"005900"', add
label define incwage_lbl 006000 `"006000"', add
label define incwage_lbl 006100 `"006100"', add
label define incwage_lbl 006200 `"006200"', add
label define incwage_lbl 006300 `"006300"', add
label define incwage_lbl 006400 `"006400"', add
label define incwage_lbl 006500 `"006500"', add
label define incwage_lbl 006600 `"006600"', add
label define incwage_lbl 006700 `"006700"', add
label define incwage_lbl 006800 `"006800"', add
label define incwage_lbl 006900 `"006900"', add
label define incwage_lbl 007000 `"007000"', add
label define incwage_lbl 007100 `"007100"', add
label define incwage_lbl 007200 `"007200"', add
label define incwage_lbl 007300 `"007300"', add
label define incwage_lbl 007400 `"007400"', add
label define incwage_lbl 007500 `"007500"', add
label define incwage_lbl 007600 `"007600"', add
label define incwage_lbl 007700 `"007700"', add
label define incwage_lbl 007800 `"007800"', add
label define incwage_lbl 007900 `"007900"', add
label define incwage_lbl 008000 `"008000"', add
label define incwage_lbl 008100 `"008100"', add
label define incwage_lbl 008200 `"008200"', add
label define incwage_lbl 008300 `"008300"', add
label define incwage_lbl 008400 `"008400"', add
label define incwage_lbl 008500 `"008500"', add
label define incwage_lbl 008600 `"008600"', add
label define incwage_lbl 008700 `"008700"', add
label define incwage_lbl 008800 `"008800"', add
label define incwage_lbl 008900 `"008900"', add
label define incwage_lbl 009000 `"009000"', add
label define incwage_lbl 009100 `"009100"', add
label define incwage_lbl 009200 `"009200"', add
label define incwage_lbl 009300 `"009300"', add
label define incwage_lbl 009400 `"009400"', add
label define incwage_lbl 009500 `"009500"', add
label define incwage_lbl 009600 `"009600"', add
label define incwage_lbl 009700 `"009700"', add
label define incwage_lbl 009800 `"009800"', add
label define incwage_lbl 009900 `"009900"', add
label define incwage_lbl 010000 `"010000"', add
label define incwage_lbl 999998 `"Missing"', add
label define incwage_lbl 999999 `"N/A"', add
label values incwage incwage_lbl
