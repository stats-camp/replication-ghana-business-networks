*--------------------------------------------
*Purpose: Clean file  to create tables/figures
*Inputs: gender_gaps_ghana.dta
*Date: 3/7/2025
*--------------------------------------------
* Load raw dataset
use "${data}/raw/gender_gaps_ghana.dta", clear

**********************************************
* Business and Personal Background Information
**********************************************

* Rename survey variables 
rename a5 age
rename a16 years_operation
rename a17 monthly_revenues
rename b3 education
rename b4 marital_status
rename b8 children

* Generate dummy variable if female
gen female = gender=="Female"
replace female = . if gender=="" 

* Generate dummy variable if college degree
gen collegedegree =  education==27
replace collegedegree = . if education==. | education==-666

* Cateogrize products bought/sold
split b2, parse(" ") gen(products)
reshape long products, i(caseid) j(n)
destring products, replace
gen product_aginput_aux = 1 if products>=1 & products<=7  		// Agricultural inputs
gen product_livestock_aux = 1 if products>=8 & products<=14		// Livestock
gen product_crop_aux = 1 if products>=15 & products<=49			//Crops
gen product_cocoa_aux = 1 if products>=50 & products<=51  		// Cocoa
gen product_forestry_aux = 1 if products>=53 & products<=55 	// Forestry
gen product_fish_aux = 1 if products>=56 & products<=57 		// Fishing
gen product_processed_aux = 1 if products>=58 & products<=63 	// Processed Agricultural products
gen product_other_aux = 1 if products ==-666  					// Other products

sort caseid 
foreach x in aginput livestock crop cocoa forestry fish processed other{
	by caseid: egen product_`x' = max(product_`x'_aux)
	drop product_`x'_aux
}
	
keep if n==1 
drop products
drop n 


foreach x in aginput livestock crop cocoa forestry fish processed other{
	replace product_`x' = 0 if product_`x'==.
	replace product_`x' = . if b2==""
}

* Generate dummy if married (3- married & 4- consensual union)
gen married = marital_status == 3 | marital_status == 4
replace married = . if marital_status ==. 

* Generate dummy if primary source of income from business activities
gen business_primary_inc = b11b==1 
replace business_primary_inc = . if business_primary_inc==.

* Generate dummy if another source of income
gen work_for_pay = b11c_1==1 | b11c_2==1 |  b11c_3==1 |  b11c_4==1 | b11c_5==1
replace work_for_pay =. if b11c ==""

* Generate dummy if location of business at home
gen business_at_home = b13== 1 | b13==2
replace business_at_home = . if b13==. | b13==-666

* # of people they go to help, # of women they go to help, # of friend/relatives they go help
gen any_business_help = b26==1
replace any_business_help = . if b26==.

gen business_help_n = 0 if b26==2
replace business_help_n = 1 if b26c==2
replace business_help_n = 2 if b26c1==2
replace business_help_n = 3 if b26c2==2
replace business_help_n = 4 if b26c3==2
replace business_help_n = 5 if b26c3==1

* Business owner is female (went to for help)
gen business_help_women = 0 
foreach x in b26a b26a_1 b26a_2 b26a_3 b26a_4{
	replace business_help_women = business_help_women + 1 if `x'==2
}
replace business_help_women = . if business_help_n==. | business_help_n==0
gen share_business_help_women = business_help_women/business_help_n

* Business owner is friend/relative (went to for help)
gen business_help_friends = 0 
gen business_help_relatives = 0 
gen business_help_friendrel = 0 
gen business_help_assoc = 0 
foreach x in b26b b26b_1 b26b_2 b26b_3 b26b_4{
	replace business_help_friends = business_help_friends + 1 if `x'==1
	replace business_help_relatives = business_help_relatives + 1 if `x'==2
	replace business_help_friendrel = business_help_friendrel + 1 if `x'==1 | `x'==2 
	replace business_help_assoc = business_help_assoc + 1 if `x'==3
}
replace business_help_friends = . if business_help_n==. | business_help_n==0
gen share_business_help_friends = business_help_friends/business_help_n

replace business_help_relatives = . if business_help_n==. | business_help_n==0
gen share_business_help_relatives = business_help_relatives/business_help_n

replace business_help_friendrel = . if business_help_n==. | business_help_n==0
gen share_business_help_friendrel = business_help_friendrel/business_help_n

replace business_help_assoc = . if business_help_n==. | business_help_n==0
gen share_business_help_assoc = business_help_assoc/business_help_n

* Generate dummy if member of a business association 
gen business_association = b27 ==1
replace business_association = . if b27==. 

* Generate dummy if meet with other business owners 
gen meet_other_business =  b28==1
replace meet_other_business = . if b28==. 

* Frequency of meeting if meeting other business owners
gen meet_other_business_freq = b28a 

* # of business owners they talk to and shares
gen meet_other_business_n = b28b 
replace meet_other_business_n = 0 if meet_other_business==0

gen meet_other_business_women =  b28b_1
gen meet_other_business_friendrel =  b28b_2

gen share_meet_business_women =  meet_other_business_women/meet_other_business_n
gen share_meet_business_friendrel =  meet_other_business_friendrel/meet_other_business_n


* # of different types of collaborations
egen total_collab = rowtotal(b30a-b30g), missing

*******************************
*-Supplier-related information
*******************************

* # of suppliers purchases were made from
gen suppliers_n = b32a

* # of important suppliers
gen suppliers_impt_n = 0
foreach x in b32b1 b32b1_2 b32b1_3{
	replace suppliers_impt_n = suppliers_impt_n + 1 if  `x'!=""
}

* Generate variable if important suppliers were women
gen suppliers_impt_women = 0 
foreach x in b32b2 b32b2_2  b32b2_3{
	replace suppliers_impt_women = suppliers_impt_women + 1 if  `x'==2
}
replace suppliers_impt_women = . if b32b2==. & b32b2_2==. & b32b2_3==.

gen share_suppliers_impt_women = suppliers_impt_women / suppliers_impt_n  // Fraction of women in important suppliers

gen any_female_suppliers = suppliers_impt_women>0 & suppliers_impt_women!=. // If any important suppliers were women

destring b32b5_2, replace
gen suppliers_impt_friendrel = 0   					// Friends and relatives as important suppliers
foreach x in b32b5 b32b5_2 b32b5_3 {
	replace suppliers_impt_friendrel = suppliers_impt_friendrel + 1 if  `x'_1==1 | `x'_2==1
}

gen share_suppliers_impt_friendrel = suppliers_impt_friendrel / suppliers_impt_n  // Fraction of friends/relatives as suppliers

*******************
*-Business clients
*******************

* # of business clients
gen clients_n = b32c

* # of important business clients
gen clients_impt_n = 0
foreach x in b32d1 b32d1_2 b32d1_3{
	replace clients_impt_n = clients_impt_n + 1 if  `x'!=""
}

* Generate variable if important client is a women
gen clients_impt_women = 0 
foreach x in b32d2 b32d2_2  b32d2_3{
	replace clients_impt_women = clients_impt_women + 1 if  `x'==2
}
replace clients_impt_women = . if b32d2==. & b32d2_2==. & b32d2_3==.

gen share_clients_impt_women = clients_impt_women / clients_impt_n  	// Share of women clients

gen any_female_clients = clients_impt_women>0 & clients_impt_women!=. 	// Any female clients

* Generate variable if important client are friends/relatives
destring  b32d5_2 ,replace
gen clients_impt_friendrel = 0 
foreach x in b32d5 b32d5_2 b32d5_3 {
	replace clients_impt_friendrel = clients_impt_friendrel + 1 if  `x'_1==1 | `x'_2==1
}

gen share_clients_impt_friendrel = clients_impt_friendrel / clients_impt_n  // Share of friends/relatives

*************************
*-Employment Information
*************************

* # of hours spent on business last week
gen hours_business = c1

* # of hours spent working for for salary
gen hours_salary = c3a

*# of hours spent taking care of children / other family members
gen hours_childcare = c3b

* # of wage/salaried workers
gen workers_wage = c4a

* # of casual / daily paid workers 
gen workers_casual = c4b 

* # of unpaid workers 
gen workers_unpaid = c4c

* # of total workers
egen workers_total = rowtotal(workers_wage workers_casual workers_unpaid)

* # of total female workers
gen workers_female = c5a

* Share of workers that are female
gen workers_female_share = workers_female/workers_total
replace workers_female_share = . if workers_female_share >1 & workers_female_share!=. 

***********************
*-Business environment 
***********************

* Generate dummy if business exports
gen export = d1 ==1 
replace export =. if d1 ==.

* Total sales in the last month
gen sales_lastmonth = g4
gen logsales_lastmonth = log(sales_lastmonth)

* Total profits last monthly_revenues
gen profits_lastmonth = g6

***********************************
* Network-related index generation
***********************************

* Index generation for business networks
local i = 1
local vars business_help_n meet_other_business meet_other_business_n business_association total_collab suppliers_n clients_n
foreach v of local vars{
	gen aux_`i' = `v'
	local i = `i' + 1
}

* Business network index used in Table 2 regressions
zindex aux_* , gen(business_network_index)  
drop aux_*

local i = 1
local vars share_business_help_friendrel share_meet_business_friendrel share_suppliers_impt_friendrel 
foreach v of local vars{
	gen aux_`i' = `v'
	local i = `i' + 1
}

* Friends/Relatives Networking Index used in Table 3 regression
zindex aux_* , gen(business_network_friendrel_index)  
drop aux_*

local i = 1
local vars share_business_help_women share_meet_business_women share_suppliers_impt_women share_clients_impt_women
foreach v of local vars{
	gen aux_`i' = `v'
	local i = `i' + 1
}

* Female Networking Index used in Table 3 regression
zindex aux_* , gen(business_network_female_index)  
drop aux_*


* Save dataset for regressions and tables
save "${data}/analysis/gender_gaps_ghana_clean.dta", replace
