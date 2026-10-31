*----------------------------------------------------------
*Purpose: Create regression tables and figures for analysis
*Inputs: gender_gaps_ghana_clean.dta
*Date: 3/7/2025
*----------------------------------------------------------

use  "${data}/analysis/gender_gaps_ghana_clean.dta", clear


* create summary statistics table
local variables profit years_operation workers_total  business_at_home hours_business hours_salary hours_childcare product_aginput product_livestock product_crop product_cocoa product_forestry product_fish product_processed product_other married age collegedegree children business_primary_inc work_for_pay

lab var logsales_lastmonth "Log revenues last month (GHS)"
lab var profit "Profit last month (GHS)"
lab var years_operation "Years in operation"
lab var workers_total "Total workers (excl. owner)"
lab var workers_female_share "Female share of workers (excl. owner)"
lab var business_at_home "Business located at home"
lab var hours_business "Hours worked at business last week"
lab var hours_salary "Hours worked at wage employment last week"
lab var hours_childcare "Hours spent caregiving last week"
lab var product_aginput "\quad Agricultural inputs"
lab var product_livestock "\quad Livestock"
lab var product_crop "\quad Crops"
lab var product_cocoa "\quad Cocoa"
lab var product_forestry "\quad Forestry"
lab var product_fish "\quad Fishing"
lab var product_processed "\quad Agro-Processing"
lab var product_other "\quad Other"
lab var married "Married or in partnership"
lab var age "Age"
lab var collegedegree "College degree"
lab var children "Number of children"
lab var business_primary_inc "Primary income from business"
lab var work_for_pay "Work for pay"

eststo clear
estpost sum `variables'
est store A

estpost sum `variables' if female==0
est store B

estpost sum `variables' if female==1
est store C

estpost ttest `variables', by(female) 
est store D



esttab A B C D using "${output_tables}/Table1.tex", replace cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2)) p(pattern(0 0 0 1) par fmt(2))" )  star(* .10 * .05 ** .01)  ///
 label nonum collabels("Mean" "\(\beta\)" "\(p\)-value") booktabs wide mtitles("All" "Male" "Female" "Difference") refcat(product_aginput "Products", nolabel)

 
 
use  "${data}/analysis/gender_gaps_ghana_clean.dta", clear

//graph version	
local i = 1
foreach y in business_help_n meet_other_business meet_other_business_n business_association total_collab suppliers_n clients_n {
	if "`y'"=="meet_other_business_n"{
		local ylabel "ylabel(0(.5)2)"
	}
	else if "`y'"=="business_help_n"{
		local ylabel "ylabel(0(.2).8)"
	}
	else if "`y'"=="meet_other_business"{
		local ylabel "ylabel(0(.1).4)"
	}
	else if "`y'"=="business_association"{
		local ylabel "ylabel(0(.05).2)"
	}
	else if "`y'"=="total_collab"{
		local ylabel "ylabel(0(1)7)"
	}
	matrix results_`i' = J(1,3,.)
	matrix female_`i' = J(1,3,.)
	matrix coln female_`i' = mean ll95 ul95
	matrix male_`i' = J(1,3,.)
	matrix coln male_`i' = mean ll95 ul95
	
	reg `y' female,r

	
	matrix female_`i'[1,1] = _b[_cons]+_b[female], _b[_cons]+_b[female]-1.96*_se[female], _b[_cons]+_b[female]+1.96*_se[female]
	matrix male_`i'[1,1] = _b[_cons]	
	matrix results_`i'[1,1] = _b[female], _b[female]-1.96*_se[female], _b[female]+1.96*_se[female]
	local i = `i' + 1

	
}
		
coefplot ///
	(matrix(male_1[,1]), noci label(Male) rename(r1="# Business Owners for Advice") offset(0) color(navy)) (matrix(female_1[,1]), ci((female_1[,2] female_1[,3])) color(maroon) label("Female") rename(r1="# Business Owners for Advice") offset(-0.3)) ///
	(matrix(male_3[,1]), noci nokey rename(r1="# Business Owners Meet Regularly") offset(0) color(navy)) (matrix(female_3[,1]), ci((female_3[,2] female_3[,3])) color(maroon) nokey rename(r1="# Business Owners Meet Regularly") offset(-0.3)) ///
	(matrix(male_5[,1]), noci nokey rename(r1="# Business Collaborations") offset(0) color(navy)) (matrix(female_5[,1]), ci((female_5[,2] female_5[,3])) color(maroon) nokey rename(r1="# Business Collaborations") offset(-0.3)) ///
	(matrix(male_6[,1]), noci nokey rename(r1="# Suppliers") offset(0) color(navy)) (matrix(female_6[,1]), ci((female_6[,2] female_6[,3])) color(maroon) nokey rename(r1="# Suppliers") offset(-0.3)) ///
	(matrix(male_7[,1]), noci nokey rename(r1="# Clients") offset(0) color(navy)) (matrix(female_7[,1]), ci((female_7[,2] female_7[,3])) color(maroon) nokey rename(r1="# Clients") offset(-0.3)) , ///
	 ytitle("") xline(0 ,lcolor(gs5)) ///
	 recast(bar) barwidth(0.25) fcolor(*.75) citop ciopts(recast(rcap) color(gs8)) ///
	 base omitted  ///
	 mlabel mlabcolor(black) mlabp(2) mlabg(*1.2) mlabf(%9.2f)  ///
	 legend(position(6)) ///
	 plotregion(fcolor(white)) graphregion(fcolor(white) ifcolor(white) color(white) icolor(white)) bgcolor(white)  legend(rows(1)) grid(glcolor(gs14) glpattern(dash)) 
	 graph export "${output_figures}/Figure1a.eps",replace
		
local i = 1
foreach y in share_business_help_women share_meet_business_women share_suppliers_impt_women share_clients_impt_women {
	matrix results_`i' = J(1,3,.)
	matrix coln results_`i' = mean ll95 ul95
	
	reg `y' female,r
	matrix results_`i'[1,1] = _b[female], _b[female]-1.96*_se[female], _b[female]+1.96*_se[female]
	local i = `i' + 1
	
}
local i = 1
foreach y in share_business_help_friendrel share_meet_business_friendrel share_suppliers_impt_friendrel share_clients_impt_friendrel {
	matrix results2_`i' = J(1,3,.)
	matrix coln results2_`i' = mean ll95 ul95
	
	reg `y' female,r
	matrix results2_`i'[1,1] = _b[female], _b[female]-1.96*_se[female], _b[female]+1.96*_se[female]
	local i = `i' + 1
	
}

coefplot ///
	(matrix(results_1[,1]), ci((results_1[,2] results_1[,3])) rename(r1="Business Owners for Advice") offset(0) label(" Female Share") ///
	 mcolor(navy) ciopts(color(navy)) mlabsize(medium)) ///
	 (matrix(results2_1[,1]), ci((results2_1[,2] results2_1[,3])) rename(r1="Business Owners for Advice") offset(-0.3) label("Friends or Relatives Share") ///
	 mcolor(navy*.50) ciopts(color(navy*.50)) mlabsize(medium)) ///
	 (matrix(results_2[,1]), ci((results_2[,2] results_2[,3])) rename(r1="Business Owners Meet Regularly") offset(0) nokey ///
	 mcolor(navy) ciopts(color(navy)) mlabsize(medium)) ///
	 (matrix(results2_2[,1]), ci((results2_2[,2] results2_2[,3])) rename(r1="Business Owners Meet Regularly") nokey offset(-0.3) ///
	 mcolor(navy*.50) ciopts(color(navy*.50)) mlabsize(medium)) ///
	 (matrix(results_3[,1]), ci((results_3[,2] results_3[,3])) rename(r1="Suppliers") offset(0) nokey ///
	 mcolor(navy) ciopts(color(navy)) mlabsize(medium)) ///
	 (matrix(results2_3[,1]), ci((results2_3[,2] results2_3[,3])) rename(r1="Suppliers") offset(-0.3) nokey ///
	 mcolor(navy*.50) ciopts(color(navy*.50)) mlabsize(medium)) ///
	 (matrix(results_4[,1]), ci((results_4[,2] results_4[,3])) rename(r1="Business Clients") offset(0) nokey ///
	 mcolor(navy) ciopts(color(navy)) mlabsize(medium)) ///
	 (matrix(results2_4[,1]), ci((results2_4[,2] results2_4[,3])) rename(r1="Business Clients") offset(-0.3) nokey ///
	 mcolor(navy*.50) ciopts(color(navy*.50)) mlabsize(medium)) , ///
	 ytitle("") xline(0 ,lcolor(gs5)) ///
	 base omitted ///
	 legend(position(6)) ///
	 plotregion(fcolor(white)) graphregion(fcolor(white) ifcolor(white) color(white) icolor(white)) bgcolor(white)  legend(rows(1)) xlabel(-.2(.2).6) grid(glcolor(gs14) glpattern(dash)) 
	 graph export "${output_figures}/Figure1b.eps",replace
 

gen m_business_network_female_index = mi(business_network_female_index)
replace business_network_female_index = -9 if mi(business_network_female_index) 

gen m_business_network_friendrel = mi(business_network_friendrel_index)
replace business_network_friendrel_index = -9 if mi(business_network_friendrel_index)

gen m_business_network_index = mi(business_network_index)
replace business_network_index = -9 if mi(business_network_index)


lab var business_network_index "Networking Index"
lab var business_network_female_index "Female Networking Index"
lab var business_network_friendrel_index "Friends/Relatives Networking Index"


local controls age years_operation business_primary_inc 
local controls2 product_aginput product_livestock product_crop product_cocoa product_forestry product_fish product_processed

lab var female "Female"
eststo clear 
eststo: reg profit female `controls',r
sum profit
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg profit female business_network_index m_business_network_index `controls', r
sum profit
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg profit female business_network_female_index m_business_network_female_index `controls', r
sum profit
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg profit female business_network_friendrel_index m_business_network_friendrel `controls', r
sum profit
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg profit female business_network_index business_network_female_index business_network_friendrel_index m_business_network_index m_business_network_female_index m_business_network_friendrel `controls', r
sum profit
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg profit female business_network_index business_network_female_index business_network_friendrel_index m_business_network_index m_business_network_female_index m_business_network_friendrel `controls' `controls2', r
sum profit
estadd scalar mean `r(mean)', replace
estadd local industry "Yes" , replace

esttab using "${output_tables}/Table3.tex", replace ///
	 keep(female business_network_index business_network_female_index business_network_friendrel_index) se star(* .10 ** .05 *** .01) r2 ///
	 s(industry mean r2 N , ///
     label("Product FE" "Mean" "\(R^2\)" "N")) ///
	 label nomtitles ///
	 booktabs f noomitted nobaselevel
	 

replace business_network_index = . if business_network_index == -9

foreach x in collegedegree business_at_home hours_childcare{
	gen m_`x' = mi(`x')

	replace `x' = -9 if mi(`x')
}


eststo clear
eststo: reg business_network_index female `controls' ,r 
sum business_network_index 
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg business_network_index female collegedegree m_collegedegree `controls' ,r 
sum business_network_index
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg business_network_index female business_at_home m_business_at_home `controls' ,r 
sum business_network_index
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg business_network_index female hours_childcare m_hours_childcare `controls' ,r 
sum business_network_index
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg business_network_index female collegedegree business_at_home hours_childcare m_collegedegree m_business_at_home m_hours_childcare `controls',r 
sum business_network_index
estadd scalar mean `r(mean)', replace
estadd local industry "No" , replace

eststo: reg business_network_index female collegedegree business_at_home hours_childcare m_collegedegree m_business_at_home m_hours_childcare `controls' `controls2',r 
sum business_network_index
estadd scalar mean `r(mean)', replace
estadd local industry "Yes" , replace

lab var collegedegree "College Degree"
lab var business_at_home "Business at Home"
lab var children "Number of Children"
lab var hours_childcare "Hours Spent Caregiving Last Week"

esttab using "${output_tables}/Table2.tex", replace ///
	 keep(female collegedegree business_at_home hours_childcare) se star(* .10 ** .05 *** .01) r2 ///
	 s(industry mean r2 N , ///
     label("Product FE" "Mean" "\(R^2\)" "N") fmt(%9.3f  %9.3f %9.3f %9.0f)) ///
	 label nomtitles ///
	 booktabs f noomitted nobaselevel

