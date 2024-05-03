* FIGURE 3
capture: ssc install coefplot
capture: ssc install estout
capture: ssc install egenmore
adopath
set matsize 1000
ssc install binscatter
import delimited "Data/Womply - ZCTA - 2020.csv"
save "Data/Womply - ZCTA - 2020.dta", replace
clear
import delimited "Data/Census RentbyZip.csv"
replace v2 = subinstr(v2, "ZCTA5 ", "", .)
destring v2, generate(zcta) force
destring v9, generate(rent_2bed) force
collapse (mean) rent_2bed, by(zcta)
merge 1:1 zcta using "Data/Womply - ZCTA - 2020.dta"
binscatter revenue_all_apr2020 rent_2bed, line(lfit)                     ///
ytitle("Change in Small Business Revenue (%)from January to April 2020", size(small))                               ///
	   xtitle("Median Two Bedroom Monthly Rent in 2014-2018 ($)", size(small))                     ///
	   title("Changes in Small Business Revenues vs. Median Two Bedroom Rent, by ZIP", size(medsmall))
graph export Figures/fig_3.png, as(png) replace
clear
