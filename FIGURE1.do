* FIGURE 1A
capture: ssc install coefplot	/* The "capture" suppresses breaks due to errors (in this case, if coefplot already installed) */
capture: ssc install estout
set matsize 1000
import delimited "Data/Affinity - National - Daily.csv"
drop if year <= 2019
drop if year >=2022
gen date = mdy(month, day, year)
format date %dM_d,_CY
gen BIQ = spend_s_all_q1*3.5+3.5
gen TIQ = spend_s_all_q4*8.3+8.3
twoway (line BIQ date, sort) (lfit BIQ date) (line TIQ date, sort) (lfit TIQ date), ytitle(Credit and Debit Card Spending Per Day ($ Billions)) ylabel(, valuelabel) xtitle(Date) title(Spending Changes by Income Quartile) legend(label(1 "Bottom Income Quartile") label(3 "Top Income Quartile"))
graph export Figures/fig_1A.png, as(png) replace
clear 

*FIGURE 1B
capture: ssc install coefplot	/* trying to get the subgroups underneath to show up or stack properly*/
capture: ssc install estout
set matsize 1000
import delimited "Data/Affinity Industry Composition - National - 2020.csv"
gen seqnum=_n
gen I = 9-seqnum
reshape long share_, i(I) j(type) string
encode type, generate(Type)
bys Type (I) : replace share_ = sum(share_)
bys Type (I) : replace share_ = share_/share_[_N]*100

twoway bar share_ Type if I == 8, barwidth(.5) || ///
       bar share_ Type if I == 7, barwidth(.5) || ///
       bar share_ Type if I == 6, barwidth(.5) || ///
       bar share_ Type if I == 5, barwidth(.5) || ///
       bar share_ Type if I == 4, barwidth(.5) || ///
	bar share_ Type if I == 3, barwidth(.5) || ///
       bar share_ Type if I == 2, barwidth(.5) || ///
	   bar share_ Type if I == 1, barwidth(.5)   ///
       legend(order(1 "Durable Goods"                    ///
                    2 "Non-Durable Goods"                        ///
                    3 "Remote Services"                      ///
                    4 "Other In-Person Services"                         ///
                    5 "Recreation"                       	///
			6 "Health Care"                      ///
                    7 "Transportation"                         ///
                    8 "Hotels and Fuel"))                       ///
       ytitle(Percent)                               ///
	   xtitle(Date) xlabel(1 "Share of Decline(Jan to Mar 25-Apr 14)" 2 "Share of Pre-COVID Spending", noticks ) title(Spending Changes by Sector)
graph export Figures/fig_1B.png, as(png) replace
clear 
