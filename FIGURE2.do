* FIGURE 2
capture: ssc install coefplot	/* The "capture" suppresses breaks due to errors (in this case, if coefplot already installed) */
capture: ssc install estout
capture: ssc install egenmore
adopath
set matsize 1000
ssc install binscatter
ssc install outreg2
import delimited "Data/Affinity - County - Daily.csv"
drop if spend_all == .
drop if year >=2021
drop if month <=2 | month >=5
drop if month==3 & day <=25
drop if month==4 & day >=14
collapse (mean) spend_all, by(countyfips)
save "Data/Affinity - County FIG2.dta", replace
clear
import delimited "Data/COVID - County - Daily 2020.csv"
drop if new_case_count == .
drop if year >=2021
drop if month >=5
drop if month==4 & day <=14
collapse (mean) case_rate, by(countyfips)
save "Data/COVID - County FIG2.dta", replace
merge 1:1 countyfips using "Data/Affinity - County FIG2.dta"
drop _merge
save "Data/COVID+Affinity - County FIG2.dta", replace
clear
import delimited "Data/Census IncomebyCounty.csv"
replace v1 = subinstr(v1, "0500000US", "", .)
destring v1, generate(countyfips) force
destring v125, generate(median_income) force
collapse (mean) median_income, by(countyfips)
merge 1:1 countyfips using "Data/COVID+Affinity - County FIG2.dta"
egen quartile_median_income=xtile(median_income), n(4)
drop if quartile_median_income ==2 | quartile_median_income ==3
binscatter spend_all case_rate, by(quartile_median_income) xscale(log) xlabel(25 50 100 200 400 800) line(lfit) reportreg legend(on position(2) ring(0) order(1 "Low Income Counties" 2 "High Income Counties ")) ytitle("Change in Consumer Spending (%) from January to April 2020", size(small))                               ///
	   xtitle("County-level COVID-19 Cases Per 100,000 People (Log Scale)", size(small)) title("Association Between COVID-19 Incidence and Changes in Consumer Spending", size(medsmall))
graph export Figures/fig_2.png, as(png) replace
reg spend_all case_rate if quartile_median_income==4
outreg2 using Covid19HighIncomeSpending, tex replace ctitle(Effect of Covid-19 Cases on Consumer Spending Changes High Income)
outreg2 using Covid19HighIncomeSpending, word replace ctitle(Effect of Covid-19 Cases on Consumer Spending Changes High Income)
reg spend_all case_rate if quartile_median_income==1
outreg2 using Covid19LowIncomeSpending, tex replace ctitle(Effect of Covid-19 Cases on Consumer Spending Changes Low Incomee)
outreg2 using Covid19LowIncomeSpending, word replace ctitle(Effect of Covid-19 Cases on Consumer Spending Changes Low Income)
clear
