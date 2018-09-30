/*無子を分析から除外*/
bysort id: egen maxccnumttl = max(ccnumttl)
drop if maxccnumttl == 0
gen quit = timeen <= length & length ~= 326 &  timeen ~= 0 
replace quit =. if timeen == . | timest == .
drop if quit ==. 
bysort id: gen sumquit = sum(quit)
drop if sumquit > 1

drop if length < cbirth1+2
gen lmonth = (length - cbirth1 - 2) + 1

/*drop if type1 == 3*/
keep if type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=.

local shortcut "lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= ."

cd "/Users/fumiyau/Documents/GitHub/JGSSLCSPatLeave/Results/Descriptive/Column"
quietly estpost tabulate redu cc01leav if `shortcut'
quietly esttab . using desc1.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate spedu cc01leav if `shortcut'
quietly esttab . using desc2.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate bch1 cc01leav if `shortcut'
quietly esttab . using desc3.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate jobssm cc01leav if `shortcut'
quietly esttab . using desc4.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate type cc01leav if `shortcut'
quietly esttab . using desc5.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate szl cc01leav if `shortcut'
quietly esttab . using desc6.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate pld cc01leav if `shortcut'
quietly esttab . using desc7.csv, replace cell(colpct(fmt(2))) unstack noobs
cd "/Users/fumiyau/Documents/GitHub/JGSSLCSPatLeave/Results/Descriptive/Row"
quietly estpost tabulate redu cc01leav if `shortcut'
quietly esttab . using desc1.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate spedu cc01leav if `shortcut'
quietly esttab . using desc2.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate bch1 cc01leav if `shortcut'
quietly esttab . using desc3.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate jobssm cc01leav if `shortcut'
quietly esttab . using desc4.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate type cc01leav if `shortcut'
quietly esttab . using desc5.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate szl cc01leav if `shortcut'
quietly esttab . using desc6.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate pld cc01leav if `shortcut'
quietly esttab . using desc7.csv, replace cell(rowpct(fmt(2))) unstack noobs

tab  redu cc01leav if `shortcut',chi row nofreq
tab  spedu cc01leav if `shortcut',chi row nofreq
tab  bch1 cc01leav if `shortcut',chi row nofreq
tab  jobssm cc01leav if `shortcut',chi row nofreq
tab  type cc01leav if `shortcut',chi row nofreq
tab  szl cc01leav if `shortcut',chi row nofreq
tab  pld cc01leav if `shortcut',chi row nofreq
ttest tenure if `shortcut', by(cc01leav)

cd "/Users/fumiyau/Documents/GitHub/JGSSLCSPatLeave/Results/Descriptive"
quietly logit cc01leav i.redu  i.spedu i.bch1 i.jobssm  i.type  i.szl i.pld tenure if `shortcut', nolog noemptycells
est sto logit
quietly esttab logit using lcs_reg_logit.csv, se scalar(N ll aic r2_p) star(† 0.1 * 0.05 ** 0.01 *** 0.001) b(3)  replace label  wide  noomitted title(Exploration: Including Cases after 2011)

