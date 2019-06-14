*=============================14 June 2019======================================
*=============================Sherry Lu=========================================
*==========================prepare for batch 4 data=============================
* note: this code file is based on the structure from "report on household screener_w_LC comment.docx"
* the main task here is to summarize patterns and report for household information data. 
* data on screener is from Batch4, HB: pcg relationship to HoH and sets E is from batch4
* CB: relationship to child, H2-H3 whether mom/dad work is from batch3(not final)
* all combine together is "S_report_prepared_B4"
* in the future when CB_batch 4 is ready, the data on CB could simply be replaced using the following code


*1.family members- how many kids, family members
*2.living arrangement - with grandparents, with helpers
*3.type of household - HDB/condo
*4.grandparents as pcg 
*5.race - 
*6.nationality
*7.educational level - parents education and children education 
*8.occupation - pcg's and parents
*9.marital status
*10.lenth of staying - foreign spouse
*children's sex and race and birth place

/* open data
clear
use "D:\DATA\D1report\20190418HHI.dta"
* merged some variables from child booklet, such as, relationship to child, ///
* living arrangement to child, and child health outcome, maternal health/behavior
* name that merged file as "report_testing_w_cb_health"

use "D:\DATA\B1_Data\Batch3 Merged dataset (not final)\batch3_merged_data",clear 

keep HHID CB_B1_A-CB_B1_H_2 CB_Q4 CB_Q4_SPECIFY CB_Q6 CB_Q6_1_SPECIFY-CB_Q6_MEMBER1 ///
CB_A2- CB_A2_C_MONTHS CB_A15- CB_A18_R_SPECIFY CB_L9- CB_L15_CM

merge m:1 HHID using "D:\DATA\D1report\20190418HHI.dta"

use "D:\DATA\D1report\report_testing_w_cb_health", clear

* A1 find the family members(total)
/*try to use the generate each dummy for the S_A13_1-S_A13_15. 
foreach x of numlist 1/15 {
gen dummy_S_A13_`x'= 1 if S_A13_`x' != "Not applicable based on skipping pattern"
}

egen tot_mber = rowtotal(dummy_S_A13_1 dummy_S_A13_2 dummy_S_A13_3 dummy_S_A13_4 dummy_S_A13_5 dummy_S_A13_6 ///
//dummy_S_A13_7 dummy_S_A13_8 dummy_S_A13_9 dummy_S_A13_10 dummy_S_A13_11 dummy_S_A13_12 dummy_S_A13_13 dummy_S_A13_14 dummy_S_A13_15)*/
 
 

* A2 find household that has grandparents as pcg
gen pcg=CB_Q6, after (CB_Q6)
lab var pcg "combine the spfc rlsp to kids"

replace pcg = CB_Q6_3_SPECIFY if pcg!="Mother" & pcg!="Father" //18 changes
replace pcg = CB_Q6_4_SPECIFY if pcg=="" //11 changes
replace pcg="Grandma" if pcg=="Gra dma" | pcg == "Grand mother" | pcg == "Grandmother"
replace pcg = "Grandpa" if pcg == "PCG is the grandfather"

note pcg: just combine pcg specific relationship to children. ///
trying to define pcg-as-grandparents scenerio. regardless of legal gurdian or point by the court ///
CHID 12104CHILD2, pcg seems like a divorced grandmother but cohabitating with partener ///
replace pcg = "Grandma" if pcg == "Grand son" could be replace for HHID 121014, PCG A2_1 is female born in 1969 ///
grandchild living with biological mother ///
CHID 11026CHILD1, pcg seems like a adopted divorce father living with children's biological mother. a cohabitation case? maybe... ///

tab pcg, m*/


* A4 find different type of family 

// cross cultural family - different citizenships
// different visa type - one is singaporean citizen by birth and spouse isn't
// different race - both are singaporean citizens but different race | one is singapore but another isn't
// divorced family - grandparent / legal parent pcg or parents divorce
// living with both biological parents or live with only one biological parent

clear
use "D:\DATA\D1report\20190418HHI.dta"

* 1 find the family members(total)
/*try to use the generate each dummy for the S_A13_1-S_A13_15. 
foreach x of numlist 1/15 {
gen dummy_S_A13_`x'= 1 if S_A13_`x' != "Not applicable based on skipping pattern"
}

egen tot_mber = rowtotal(dummy_S_A13_1 dummy_S_A13_2 dummy_S_A13_3 dummy_S_A13_4 dummy_S_A13_5 dummy_S_A13_6 ///
//dummy_S_A13_7 dummy_S_A13_8 dummy_S_A13_9 dummy_S_A13_10 dummy_S_A13_11 dummy_S_A13_12 dummy_S_A13_13 dummy_S_A13_14 dummy_S_A13_15)*/
 
gen tot_HH_member=0
lab var tot_HH_member "tot members in the household"

foreach x of numlist 1/15 {
replace tot_HH_member=tot_HH_member + 1 if S_A13_`x' != "Not applicable based on skipping pattern"
}

tab tot_HH_member, m
 
* gen pcg spouse, so in the following, it could be a selection critiria.

gen pcg_s = 0, after (S_A2_1) 
lab var pcg_s "pcg has a spouse, 1=have, 0=does not have"
 forval x = 1/15{
 replace pcg_s = 1 if S_A2_`x' == "Spouse\Partner"
}
tab pcg_s,m


/*change HHID 253177 relationship to pcg
replace S_A2_7 = "Child" if HHID==253177 & S_A2_7 == "Spouse\Partner"
replace S_A2_4 = "Child" if HHID == 231031 & S_A2_4 == "Spouse\Partner" */

note pcg_s_birth_year: HHID 253177, the 7th family member state as spouse\partner but he was born in 2018. ///
HHID 231031, the 4th family member state as spouse\partner but she was born in 2014. the second member state father but birth year is closer to pcg. ///
HHID 53147, the 3rd family member born in 2006; ///
HHID 262014, the 4th family member relationship is child but was born in 1967 ///
HHID 51040, 3rd family member, female born in 2007, marked as partner. ///

* find pcg's age (2018-age)

gen pcg_age = 2018-S_A4_1, after (S_A4_1)
lab var pcg_age "pcg's age"

* pcg spouse age
gen pcg_s_age = 0, after (S_A4_1)
lab var pcg_s_age "pcg spouse's age"

forval x = 1/15{
replace pcg_s_age = 2018 - S_A4_`x' if S_A2_`x' == "Spouse\Partner"
}

tab pcg_s_age,m

* family member's age
global ylist S_A4_*

		foreach v of varlist $ylist{
			
			*local v
			gen age_`v'= 2018 -`v'
		}


*  find number of children (total)
gen tot_n_child=0
lab var tot_n_child "tot numb. of kids"

foreach x of numlist 2/15{
replace tot_n_child=tot_n_child +1 if age_S_A4_`x'<= 7 & age_S_A4_`x' != .
}


tab tot_n_child, m


* find pcg's gender
gen pcg_gender = S_A3_1 , after (S_A3_1)
lab var pcg_gender "pcg gender"

gen pcg_s_gender = ".",after (pcg_gender)
forval x = 1/15{
replace pcg_s_gender= S_A3_`x' if S_A2_`x' == "Spouse\Partner"
}

lab var pcg_s_gender "pcg spouse's gender"

* find pcg's race and pcg_s_race
gen pcg_race = S_A10_1, after (S_A10_1)
lab var pcg_race "pcg's race"
replace pcg_race = S_A10_1_8_OTHERS if pcg_race == "Others"

gen pcg_s_race = ".",after (pcg_race)
forval x = 1/15{
replace pcg_s_race = S_A10_`x' if S_A2_`x' == "Spouse\Partner"
}

lab var pcg_s_race "pcg spouse's race"

forval x=2/15{
 replace pcg_s_race = S_A10_`x'_8_OTHERS if S_A2_`x'=="Spouse\Partner" & pcg_s_race == "Others"
}

* find pcg's nationality
gen pcg_nation = S_A8_1, after (S_A8_1)
lab var pcg_nation "pcg's nationality"

replace pcg_nation = S_A8_1_3 if pcg_nation == "Chinese"
replace pcg_nation = S_A8_1_8 if pcg_nation == "Other nationality"
// replace pcg_nation = S_A8_1_9 if pcg_nation == "Dual\multiple citizenship"

gen pcg_s_nation = ".",after (pcg_nation)
forval x = 1/15{
replace pcg_s_nation = S_A8_`x' if S_A2_`x' == "Spouse\Partner"
}

lab var pcg_s_nation "pcg spouse's nationality"

forval x=2/15{
 replace pcg_s_nation = S_A8_`x'_8 if S_A2_`x'=="Spouse\Partner" & pcg_s_nation == "Other nationality"
}

forval x=2/15{
 replace pcg_s_nation = S_A8_`x'_9 if S_A2_`x'=="Spouse\Partner" & pcg_s_nation == "Dual\multiple citizenship"
}


forval x=2/15{
 replace pcg_s_nation = S_A8_`x'_3 if S_A2_`x'=="Spouse\Partner" & pcg_s_nation == "Chinese"
}

* find pcg's and spouses country of birth, including other specific
gen pcg_cob = S_A11_1, after (S_A11_1)
lab var pcg_cob "pcg's country of birth, including specfic"

replace pcg_cob = S_A11_1_A if pcg_cob == "Others"

gen pcg_s_cob = ".",after (pcg_cob)
forval x = 2/15{
replace pcg_s_cob = S_A11_`x' if S_A2_`x' == "Spouse\Partner"
}

lab var pcg_s_cob "pcg spouse's cob, including specific"

forval x=2/15{
 replace pcg_s_cob = S_A11_`x'_A if S_A2_`x'=="Spouse\Partner" & pcg_s_cob == "Others"
}

* find pcg's and spouses residency status
gen pcg_res_status = S_A9_1, after (S_A9_1)
lab var pcg_res_status "pcg residency status in SG"

gen pcg_s_res_status = ".", after (pcg_res_status)

forval x = 2/15{
replace pcg_s_res_status = S_A9_`x' if S_A2_`x' == "Spouse\Partner"
}
lab var pcg_s_res_status "pcg spouse's residency status"

* find pcg's and spouses num. of yrs. in SG
gen pcg_yrs_n_sg = S_A12_1, after (S_A12_1)
lab var pcg_yrs_n_sg "pcg num. of years in SG"

gen pcg_s_yrs_n_sg = . , after (pcg_yrs_n_sg)

forval x = 2/15{
replace pcg_s_yrs_n_sg = S_A12_`x' if S_A2_`x' == "Spouse\Partner"
}

lab var pcg_s_yrs_n_sg "pcg spouse's num. of years in SG"

* find pcg's marital stauts
gen pcg_mar_st=S_A5_1, after (S_A5_1)
lab var pcg_mar_st "pcg marital status"

gen pcg_s_mar_st = ".", after (pcg_mar_st)
lab var pcg_s_mar_st "pcg spouse's marital status"

forval x=2/15{
replace pcg_s_mar_st = S_A5_`x' if S_A2_`x' == "Spouse\Partner"
}
tab pcg_mar_st,m
tab pcg_s_mar_st,m

* find pcg's and spouses employment status
gen pcg_emp = S_A15_1, after (S_A15_1)
lab var pcg_emp "pcg employment status, including specific others"

replace pcg_emp = S_A15_1_8_OTHERS if pcg_emp == "Others"
note pcg_emp: when replace the others, 1 has changed to on unpaid leave and other 2 become mising information 

gen pcg_s_emp = "." , after (pcg_emp)

forval x = 2/15{
replace pcg_s_emp = S_A15_`x' if S_A2_`x' == "Spouse\Partner"
}

forval x = 2/15{
replace pcg_s_emp = S_A15_`x'_8_OTHERS if pcg_s_emp == "Others"
}

lab var pcg_s_emp "pcg spouse's employment status, including specific others"

* find pcg's occupation
gen pcg_occ = S_A16_1, after (S_A16_1)
lab var pcg_occ "pcg occupation"

gen pcg_s_occ = "."

forval x = 2/15{
replace pcg_s_occ = S_A16_`x' if S_A2_`x' == "Spouse\Partner"
}
lab var pcg_s_occ "pcg spouse occupation"

* find pcg's educational level
gen pcg_educ=S_A14_1, after (S_A14_1)
lab var pcg_educ "pcg_educational level"

gen pcg_s_educ="."

forval x = 2/15{
replace pcg_s_educ = S_A14_`x' if S_A2_`x' == "Spouse\Partner"
}
lab var pcg_s_educ "pcg spouse educational level"

* lael variables *
* age
foreach v of varlist pcg_age pcg_s_age age_S_A4_*{
	lab var `v' "`v'"
	}
	
* gender
foreach v of varlist S_A3_1 S_A3_2 S_A3_3 S_A3_4 S_A3_5 S_A3_6 S_A3_7 S_A3_8 S_A3_9 ///
S_A3_10 S_A3_11 S_A3_12 S_A3_13 S_A3_14 S_A3_15{
   lab var `v' "`v'_gender"
   }

* race
 foreach v of varlist S_A10_1 S_A10_2 S_A10_3 S_A10_4 S_A10_5 S_A10_6 S_A10_7 ///
 S_A10_8 S_A10_9 S_A10_10 S_A10_11 S_A10_12 S_A10_13 S_A10_14 S_A10_15{
   lab var `v' "`v'_race"
    }
  
* nationality
foreach v of varlist S_A8_1 S_A8_2 S_A8_3 S_A8_4 S_A8_5 S_A8_6 S_A8_7 S_A8_8 S_A8_9 ///
S_A8_10 S_A8_11 S_A8_12 S_A8_13 S_A8_14 S_A8_15{
   lab var `v' "`v'_nationality"
   }
  
* COB
foreach v of varlist S_A11_1 S_A11_2 S_A11_3 S_A11_4 S_A11_5 S_A11_6 S_A11_7 S_A11_8 S_A11_9 ///
S_A11_10 S_A11_11 S_A11_12 S_A11_13 S_A11_14 S_A11_15{
  lab var `v' "`v'_COB"
  }

* residency status
foreach v of varlist S_A9_1 S_A9_2 S_A9_3 S_A9_4 S_A9_5 S_A9_6 S_A9_7 S_A9_8 S_A9_9 ///
S_A9_10 S_A9_11 S_A9_12 S_A9_13 S_A9_14 S_A9_15{
  lab var `v' "`v'_residency status"
  }


* label marital status
foreach v of varlist S_A5_1 S_A5_2 S_A5_3 S_A5_4 S_A5_5 S_A5_6 S_A5_7 S_A5_8 S_A5_9 ///
S_A5_10 S_A5_11 S_A5_12 S_A5_13 S_A5_14 S_A5_15{
  lab var `v' "`v'_marital_status"
  }

* current years of marriage
foreach v of varlist S_A6_1 S_A6_2 S_A6_3 S_A6_4 S_A6_5 S_A6_6 S_A6_7 S_A6_8 S_A6_9 ///
S_A6_10 S_A6_11 S_A6_12 S_A6_13 S_A6_14 S_A6_15{
  lab var `v' "`v'_yrs_curt_mrage"
  }

* number of marriages
foreach v of varlist S_A7_1 S_A7_2 S_A7_3 S_A7_4 S_A7_5 S_A7_6 S_A7_7 S_A7_8 S_A7_9 ///
S_A7_10 S_A7_11 S_A7_12 S_A7_13 S_A7_14 S_A7_15{
  lab var `v' "`v'_n_of_marr"
  }

* relationship to PCG
foreach v of varlist S_A2_2 S_A2_3 S_A2_4 S_A2_5 S_A2_6 S_A2_7 S_A2_8 S_A2_9 ///
S_A2_10 S_A2_11 S_A2_12 S_A2_13 S_A2_14 S_A2_15{
  lab var `v' "`v'_rltsp_PCG"
  }
  
tab1 pcg*

compress
save "screener", replace 
