********************************************************************************
*******************D2)types of family*******************************************
*********************Sherry Lu**************************************************
*******************report on HH screener, June 7********************************
********************************************************************************

*|objective
*1. merge HB housing type variables with the Screener
*2. testing different defination about cross-cultural families
*2.1 cross-cultural families by nationality
*2.2 cross-cultural families by country of birth
*2.3 corss-cultural families (cc-f) by residence status (does not work well)
*3. listing tables for cc-f by demographic characteristics
*3.1-3.9, housing type, race, age, nationality, country of birth, residence status, marital status, education
*4. listing tables for different types of family
*4.1 family size and family size with children
*4.2 marriage types, married, divorce, cohabitation
*4.3 living with elderly, helpers
*4.4 household size and housing type 
*4.5 education profile by pcg's race
*4.6 cross-cultural marriage by pcg's race

use "20190418HB", clear
keep HHID HB_A9 HB_A9_7_OTHERS HB_A9_8_OTHERS HB_E22_A HB_E22_B HB_H40 - HB_H43

merge 1:1 HHID using "screener"

save "S_HHB", replace

use "S_HHB", clear

* find foreign-brides and foreign-grooms by their nationality only
//Female is the PCG. female is the non-sg PCG, but her spouse is sg (foreign-bride when woman is the pcg) --> assume that foreign bride have control on their kids
tab HHID if pcg_gender == "Female" & pcg_nation != "Singaporean" & pcg_nation != "." & pcg_s_nation == "Singaporean" // 191 
//Female is the PCG. female is the sg PCG, but her spouse is non-sg (foreign-groom when woman is the pcg)
tab HHID if pcg_gender == "Female" & pcg_nation=="Singaporean" & pcg_s_nation != "Singaporean" & pcg_s_nation != "." // 61
//Male is the PCG. Male is sg PCG, but his spouse is non-sg (foreign-bride when man is the pcg) --> assume that foreign bride do not have control on their kids
tab HHID if pcg_gender == "Male" & pcg_nation == "Singaporean" & pcg_s_nation != "Singaporean" & pcg_s_nation != "." // 19
//Male is the PCG. Male is not sg, but his spouse is sg (foreign-groom when man is the pcg)
tab HHID if pcg_gender == "Male" & pcg_nation != "Singaporean" & pcg_nation != "." & pcg_s_nation == "Singaporean" // 2
//both pcg and spouse are singaporean
tab HHID if pcg_nation == "Singaporean" & pcg_s_nation == "Singaporean" // 534
//both pcg and spouse are not singaporean by nationality
tab HHID if pcg_nation != "Singaporean" & pcg_s_nation != "Singaporean" // 58

gen foreign_spouse_nation = "."

replace foreign_spouse_nation = "pcg foreign bride" if pcg_gender == "Female" & pcg_nation != "Singaporean" & pcg_nation != "." & pcg_s_nation == "Singaporean" 
replace foreign_spouse_nation = "non-pcg foreign bride" if pcg_gender == "Male" & pcg_nation == "Singaporean" & pcg_s_nation != "Singaporean" & pcg_s_nation != "."
replace foreign_spouse_nation = "pcg foreign groom" if pcg_gender == "Male" & pcg_nation != "Singaporean" & pcg_nation != "." & pcg_s_nation == "Singaporean"
replace foreign_spouse_nation = "non-pcg foreign groom" if pcg_gender == "Female" & pcg_nation=="Singaporean" & pcg_s_nation != "Singaporean" & pcg_s_nation != "."
replace foreign_spouse_nation = "both sg" if pcg_nation == "Singaporean" & pcg_s_nation == "Singaporean"
replace foreign_spouse_nation = "both non-sg" if pcg_nation != "Singaporean" & pcg_s_nation != "Singaporean"

tab foreign_spouse_nation, m
/*
foreign_spouse_nation |      Freq.     Percent        Cum.
----------------------+-----------------------------------
                    . |         61        6.54        6.54
          both non-sg |         65        6.97       13.50
              both sg |        534       57.23       70.74
non-pcg foreign bride |         19        2.04       72.78
non-pcg foreign groom |         61        6.54       79.31
    pcg foreign bride |        191       20.47       99.79
    pcg foreign groom |          2        0.21      100.00
----------------------+-----------------------------------
                Total |        933      100.00
*/
tab pcg_cob if foreign_spouse_nation == "pcg foreign bride", m
tab pcg_cob pcg_s_cob if foreign_spouse_nation == "pcg foreign groom", m


* find foreign-born-brides and foreign-born-grooms by their COB only

//Female is the PCG. female is the non-sg PCG, but PCG's spouse is Singaporeans 
tab HHID if pcg_gender == "Female" & pcg_cob != "Singapore" & pcg_cob != "." & pcg_s_cob == "Singapore" & pcg_s_gender == "Male" //206
 
//Female is the PCG. female is the Singaporean PCG, but PCG's spouse was not born in SG
tab HHID if pcg_gender == "Female" & pcg_cob=="Singapore" & pcg_s_cob != "Singapore" & pcg_s_cob != "." //40

//Male is the PCG. Male's cob is SG
tab HHID if pcg_gender == "Male" & pcg_cob == "Singapore" & pcg_s_cob != "Singapore" & pcg_s_cob != "." //20

//Male is the PCG. Male's cob is not in SG
tab HHID if pcg_gender == "Male" & pcg_cob != "Singapore" & pcg_s_cob == "Singapore" & pcg_s_cob != "."  //4 

//both pcg and spouse's cob in SG
tab HHID if pcg_cob == "Singapore" & pcg_s_cob == "Singapore" //446

tab HHID if pcg_cob != "Singapore" & pcg_s_cob != "Singapore" & pcg_s_cob != "."

gen foreign_spouse_cob = "."

replace foreign_spouse_cob = "pcg foreign bride" if  pcg_gender == "Female" & pcg_cob != "Singapore" & pcg_cob != "." & pcg_s_cob == "Singapore" & pcg_s_gender == "Male"
replace foreign_spouse_cob = "non-pcg foreign bride" if pcg_gender == "Female" & pcg_cob=="Singapore" & pcg_s_cob != "Singapore" & pcg_s_cob != "."
replace foreign_spouse_cob = "pcg foreign groom" if  pcg_gender == "Male" & pcg_cob == "Singapore" & pcg_s_cob != "Singapore" & pcg_s_cob != "."
replace foreign_spouse_cob = "non-pcg foreign groom" if pcg_gender == "Male" & pcg_cob != "Singapore" & pcg_s_cob == "Singapore" & pcg_s_cob != "."
replace foreign_spouse_cob = "both sg" if pcg_cob == "Singapore" & pcg_s_cob == "Singapore" 
replace foreign_spouse_cob = "both non-sg" if pcg_cob != "Singapore" & pcg_s_cob != "Singapore" & pcg_s_cob != "."

tab foreign_spouse_cob, m

/*
   foreign_spouse_cob |      Freq.     Percent        Cum.
----------------------+-----------------------------------
                    . |         68        7.29        7.29
          both non-sg |        149       15.97       23.26
              both sg |        446       47.80       71.06
non-pcg foreign bride |         40        4.29       75.35
non-pcg foreign groom |          4        0.43       75.78
    pcg foreign bride |        206       22.08       97.86
    pcg foreign groom |         20        2.14      100.00
----------------------+-----------------------------------
                Total |        933      100.00*/

/* find foreign brides and foreign groom by their residence status###not working. no observation for pcg_foreign bride
gen foreign_spouse_res = "."

replace foreign_spouse_res = "pcg foreign bride" if pcg_gender == "Female" & pcg_res_status != "Singapore permanent resident" ///
& pcg_res_status != "Citizen by birth" & pcg_res_status != "Citizen by conversion" & pcg_s_res_status == "Singapore permanent resident" ///
& pcg_s_res_status == "Citizen by birth" & pcg_s_res_status == "Citizen by conversion"

list if pcg_gender == "Female" & pcg_res_status != "Singapore permanent resident" ///
& pcg_res_status != "Citizen by birth" & pcg_res_status != "Citizen by conversion" & pcg_s_res_status == "Singapore permanent resident" ///
& pcg_s_res_status == "Citizen by birth" & pcg_s_res_status == "Citizen by conversion"
*/

*****3. Tables---------------------
*******by-----------------------
*****Foreign bride/grooms-------

* gen foreign bride and foreign groom regardless their pcg status

gen foreign_bride_nation = 1 if foreign_spouse_nation == "pcg foreign bride" | foreign_spouse_nation == "non-pcg foreign bride"
gen foreign_groom_nation = 1 if foreign_spouse_nation == "pcg foreign groom" | foreign_spouse_nation == "non-pcg foreign groom"

*| housing types
tab foreign_bride_nation HB_H40 
tab foreign_groom_nation HB_H40
tab foreign_spouse_nation HB_H40

*| race
tab2 foreign_spouse_nation pcg_race pcg_s_race, firstonly
tab pcg_race if foreign_spouse_nation == "pcg foreign bride"
tab pcg_s_race if foreign_spouse_nation == "non-pcg foreign bride"
tab pcg_race if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_race if foreign_spouse_nation == "non-pcg foreign groom"

*| age
tab2 foreign_spouse_nation pcg_age pcg_s_age, firstonly

*| nationality
tab pcg_nation if foreign_spouse_nation == "pcg foreign bride"
tab pcg_s_nation if foreign_spouse_nation == "non-pcg foreign bride"
tab pcg_nation if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_nation if foreign_spouse_nation == "non-pcg foreign groom"

tab2 foreign_spouse_nation pcg_nation pcg_s_nation, firstonly

*| country of birth
// pcg foreign brides cob
tab pcg_cob if foreign_spouse_nation == "pcg foreign bride"
tab pcg_s_cob if foreign_spouse_nation == "non-pcg foreign bride"
tab pcg_cob if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_cob if foreign_spouse_nation == "non-pcg foreign groom"

tab2 foreign_spouse_nation pcg_cob pcg_s_cob, firstonly

*| residence status
tab pcg_res_status if foreign_spouse_nation == "pcg foreign bride"
tab pcg_s_res_status if foreign_spouse_nation == "non-pcg foreign bride"
tab pcg_res_status if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_res_status if foreign_spouse_nation == "non-pcg foreign groom"

tab2 foreign_spouse_nation pcg_res_status pcg_s_res_status, firstonly

*| marriage 
tab pcg_mar_st if foreign_spouse_nation == "pcg foreign bride"
tab pcg_s_mar_st if foreign_spouse_nation == "non-pcg foreign bride"
tab pcg_mar_st if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_mar_st if foreign_spouse_nation == "non-pcg foreign groom"

tab2 foreign_spouse_nation pcg_mar_st pcg_s_mar_st, firstonly

*| education
tab pcg_educ if foreign_spouse_nation == "pcg foreign bride"
tab pcg_s_educ if foreign_spouse_nation == "non-pcg foreign bride"
tab pcg_educ if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_educ if foreign_spouse_nation == "non-pcg foreign groom"

tab2 foreign_spouse_nation pcg_educ pcg_s_educ, firstonly
tab pcg_educ foreign_bride_nation if foreign_spouse_nation == "pcg foreign bride"
tab pcg_educ foreign_groom_nation if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_educ if foreign_spouse_nation == "non-pcg foreign bride"

*| employment status
tab pcg_emp if foreign_spouse_nation == "pcg foreign bride"
tab pcg_s_emp if foreign_spouse_nation == "non-pcg foreign bride"
tab pcg_emp if foreign_spouse_nation == "pcg foreign groom"
tab pcg_s_emp if foreign_spouse_nation == "non-pcg foreign groom"


*| education, housing type (1-2 room, 3 room, etc) for foreign brides
tab pcg_educ HB_H40 if foreign_spouse_nation == "foreign bride"

**********************************
******4. Tables-----------------
*******Living arrangement ------
*************************************
* head of household
tab HB_A9 if S_A1_HEAD == "Yes"
tab HB_A9 if S_A1_HEAD == "No"
tab S_A1_HEAD pcg_gender
tab HB_A9 pcg_gender
/*note: HOH information from screener and HB are not consistant,detail see issue in screener.docx
	 +--------+
     |   HHID |
     |--------|
 63. |  21060 |
 81. |  22192 |
177. |  51016 |
300. |  91056 |
317. | 111010 |
     |--------|
394. | 141007 |
446. | 151062 |
478. | 231002 |
538. | 233307 |
551. | 233360 |
     |--------|
556. | 242019 |
560. | 242037 |
699. | 293352 |
703. | 293362 |
831. | 362195 |
     |--------|
880. | 371125 |
     +--------+*/


* family size

tab tot_HH_member, m

* family size with children

tab tot_HH_member tot_n_child, m

* married couples

tab pcg_mar_st pcg_s_mar_st
tab pcg_mar_st HB_E22_A

* divorced - single parent// pcg does not have spouse\partner

tab pcg_mar_st if pcg_s_mar_st != "."

tab pcg_s_mar_st if pcg_s_mar_st != "."

tab pcg_mar_st if pcg_s_mar_st == "."
tab pcg_s_mar_st if pcg_s_mar_st == "."

tab pcg_s_mar_st if pcg_mar_st == "Divorced"
tab pcg_s_mar_st if pcg_mar_st == "Never married"

// PCG's number of marriages
tab S_A7_1 
gen pcg_s_n_marr = "."

forval x = 1/15{
replace pcg_s_n_marr = S_A7_`x' if S_A2_`x'=="Spouse\Partner"
}

tab pcg_s_n_marr,m

* cohabitation // seperate or divorce but have spouse\partner live in the household (HB_E22_A)

tab pcg_mar_st if pcg_mar_st != "Currently married" & HB_E22_A == "Yes"

* households had at least one elderly aged 65 years and over

tab tot_HH_member if pcg_age >= 65
tab pcg_gender if pcg_age >=65

// number of elderly in the households
gen elderly65 = 0

forval x=1/15{
replace elderly65 = elderly65 + 1 if age_S_A4_`x' != . & age_S_A4_`x' >= 65
}

tab elderly65,m
//drop elderly65

* households that live with spouses and other caregivers (also see in HB_E22_B)
tab HB_E22_A , m
tab tot_HH_member if HB_E22_B == "Yes"

gen numhelper = 0

forval x=1/15{
replace numhelper = numhelper +1 if S_A2_`x' == "Domestic helper"
}
tab numhelper,m
drop numhelper

* Households lived in condom and other apartments (HB_H40 - HB_H43)
// if family size deterime the living space, and it does not...
tab tot_HH_member HB_H40


* Residents had no religious affiliation


* use english as the Main language at home 


* education profiles by pcg's race

tab2 pcg_race pcg_educ pcg_s_educ

* cross-racial couples

tab foreign_spouse_nation, m




/*checking the birth weight

use "foreign_by_nation", clear

tab foreign_spouse_nation CB_L12_GM if CB_L12_GM <  2500
tab foreign_spouse_nation CB_L12_GM if CB_L12_GM >  3999
tab CB_L12_GM if foreign_spouse_nation == "both sg" & CB_L12_GM > 2500 & CB_L12_GM < 3999*/ 
