use "/Users/fumiyau/Desktop/JGSS_LCS_Submission/JGSS_LCS0824.dta", clear
label variable cc01leav   "第一子育児休業取得"
label variable redu   "本人学歴"
label variable spedu   "配偶者学歴"
label variable jobssm   "本人出産時職業"
label variable jobssm1   "本人初職"
label variable type   "本人出産時従業上の地位"
label variable type1   "本人初職従業上の地位"
label variable sz1   "本人初職企業規模"
label variable szl   "本人出産時企業規模"
label variable tencat   "本人出産時勤続期間"
label variable pld   "本人出産時親同居"
label variable bch   "第一子出生コーホート"

label define reduc 1"本人学歴（ref: 中学・高校）" 2"短大・高専・専門" 3"四大以上", replace
label define speduc 1"本人学歴（ref: 中学・高校）" 2"短大・高専・専門" 3"四大以上" 4"不明", replace
label define ssm 0"本人職業（ref: 販売）"1"本人結婚時職（ref: 専門管理）"2"事務"3"販売"4"熟練・半非熟練"6"無職", replace
label define ssm1 0"本人職業（ref: 販売）"1"本人初職（ref: 専門管理）"2"事務"3"販売"4"熟練・半非熟練"6"無職", replace
label define comp 1"出産時企業規模（ref: 1-29人）"2"30-99人"3"100-299人"4"300-1999人"5"2000人以上"6"官公庁"7"わからない"10"無職", replace
label define comp1 1"出産時企業規模（ref: 1-29人）"2"30-99人"3"100-299人"4"300-1999人"5"2000人以上"6"官公庁"7"わからない"10"無職", replace
label define stat 1"出産時従業上の地位（ref: 正規雇用）"2"非正規雇用"3"自営業"4"無職", replace
label define stat1 1"初職従業上の地位（ref: 正規雇用）"2"非正規雇用"3"自営業"4"無職", replace
label define parl 1"同居"0"出産時親同居（ref: 非同居）", replace
label define car  1"出産時勤続年数（ref: 1年以内）" 2"2-3年以内" 3"4-5年以内" 4"6-10年以内" 5"11年以上", replace
label define cor 1"出産コーホート（ref: 1986-1991）" 2"1992-1994" 3"1995-2001" 4"2002-2004" 5"2005-2009", replace
label define his 1"出産歴（ref: 1人目）"2"2人目"3"3人目", replace
label define cc 0"育児休暇取得有無（ref: 非取得）" 1"取得", replace
/*label define cc 0"非取得" 1"取得", replace*/


label values bch cor
label values tencat car 
label values redu reduc
label values spedu speduc
label values jobssm ssm
label values jobssm1 ssm1
label values szl comp
label values sz1 comp1

label values type stat
label values type1 stat1
label values pld parl
label values cbex his
label values bch cor
label values bch1 cor
label values cc01leav cc

recode spedu .a=4
recode ump 1=0 if timeen == . | timest == .
recode szl sz1 (.=7)

/*この後にイベントヒストリ*/
drop if sex ==1
drop if cc01leav ==.
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

bysort iduse : egen sumid=max(lmonth) 
tab sumid if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
tab sumid cc01leav if lmonth==1 & group ~=. & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .


/*傾向スコア:empty cellの問題があるためいくつか改変

tab redu, gen(educ)
tab spedu, gen(seduc)
tab bch1, gen(cohort)
tab jobssm, gen(ssm)
tab type, gen(jobtype)
tab szl, gen(size)*/

cd "/Users/fumiyau/Desktop/JGSS_LCS_Submission/results/desc"
quietly estpost tabulate redu cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc1.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate spedu cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc2.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate bch1 cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc3.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate jobssm cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc4.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate type cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc5.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate szl cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc6.csv, replace cell(colpct(fmt(2))) unstack noobs
quietly estpost tabulate pld cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc7.csv, replace cell(colpct(fmt(2))) unstack noobs

quietly estpost tabulate redu cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc1.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate spedu cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc2.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate bch1 cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc3.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate jobssm cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc4.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate type cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc5.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate szl cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc6.csv, replace cell(rowpct(fmt(2))) unstack noobs
quietly estpost tabulate pld cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
quietly esttab . using desc7.csv, replace cell(rowpct(fmt(2))) unstack noobs

cd "/Users/fumiyau/Desktop/JGSS_LCS_Submission/results/desc"
cat desc*.csv > INPUT.csv

tab  redu cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .,chi row nofreq
tab  spedu cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .,chi row nofreq
tab  bch1 cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .,chi row nofreq
tab  jobssm cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .,chi row nofreq
tab  type cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .,chi row nofreq
tab  szl cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .,chi row nofreq
tab  pld cc01leav if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .,chi row nofreq
ttest tenure if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= ., by(cc01leav)

quietly logit cc01leav i.redu  i.spedu i.bch1 i.jobssm  i.type  i.szl i.pld tenure if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= ., nolog noemptycells
est sto logit
quietly esttab logit using lcs_reg_logit.csv, se scalar(N ll aic r2_p) star(† 0.1 * 0.05 ** 0.01 *** 0.001) b(3)  replace label  wide  noomitted title(Exploration: Including Cases after 2011)

/*1to1 matchを行う。その上で、マッチされたサンプル同士で比較*/
/*Nearest neibor within caliper 0.1 採用*/
set seed 1000
generate x=uniform()
sort x

psmatch2 cc01leav i.redu  i.spedu i.bch1 i.jobssm  i.type  i.szl i.pld tenure if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= ., logit caliper(0.1) noreplacement descending
pstest
sort _id 
drop treat match
g match=iduse[_n1]
g treat=iduse if _nn==1
list id match treat if treat ~=.
summarize match treat

tab match
/*controll特定*/
g cont =.   
replace cont=iduse if iduse== 	38
replace cont=iduse if iduse== 	45
replace cont=iduse if iduse== 	118
replace cont=iduse if iduse== 	145
replace cont=iduse if iduse== 	182
replace cont=iduse if iduse== 	210
replace cont=iduse if iduse== 	233
replace cont=iduse if iduse== 	243
replace cont=iduse if iduse== 	274
replace cont=iduse if iduse== 	293
replace cont=iduse if iduse== 	296
replace cont=iduse if iduse== 	297
replace cont=iduse if iduse== 	333
replace cont=iduse if iduse== 	383
replace cont=iduse if iduse== 	402
replace cont=iduse if iduse== 	440
replace cont=iduse if iduse== 	521
replace cont=iduse if iduse== 	582
replace cont=iduse if iduse== 	594
replace cont=iduse if iduse== 	624
replace cont=iduse if iduse== 	700
replace cont=iduse if iduse== 	734
replace cont=iduse if iduse== 	798
replace cont=iduse if iduse== 	825
replace cont=iduse if iduse== 	1049
replace cont=iduse if iduse== 	1140
replace cont=iduse if iduse== 	1179
replace cont=iduse if iduse== 	1187
replace cont=iduse if iduse== 	1207
replace cont=iduse if iduse== 	1234
replace cont=iduse if iduse== 	1238
replace cont=iduse if iduse== 	1253
replace cont=iduse if iduse== 	1285
replace cont=iduse if iduse== 	1326
replace cont=iduse if iduse== 	1363
replace cont=iduse if iduse== 	1456
replace cont=iduse if iduse== 	1502
replace cont=iduse if iduse== 	1509
replace cont=iduse if iduse== 	1511
replace cont=iduse if iduse== 	1576
replace cont=iduse if iduse== 	1589
replace cont=iduse if iduse== 	1668
replace cont=iduse if iduse== 	1675
replace cont=iduse if iduse== 	1698
replace cont=iduse if iduse== 	1704
replace cont=iduse if iduse== 	1792
replace cont=iduse if iduse== 	1818
replace cont=iduse if iduse== 	1829
replace cont=iduse if iduse== 	1873
replace cont=iduse if iduse== 	1889
replace cont=iduse if iduse== 	1909
replace cont=iduse if iduse== 	1929
replace cont=iduse if iduse== 	2000
replace cont=iduse if iduse== 	2019
replace cont=iduse if iduse== 	2025
replace cont=iduse if iduse== 	2075
replace cont=iduse if iduse== 	2089
replace cont=iduse if iduse== 	2163
replace cont=iduse if iduse== 	2167
replace cont=iduse if iduse== 	2173
replace cont=iduse if iduse== 	2207
replace cont=iduse if iduse== 	2246
replace cont=iduse if iduse== 	2265
replace cont=iduse if iduse== 	2311
replace cont=iduse if iduse== 	2374
replace cont=iduse if iduse== 	2382
replace cont=iduse if iduse== 	2445
replace cont=iduse if iduse== 	2466
replace cont=iduse if iduse== 	2491
replace cont=iduse if iduse== 	2554
replace cont=iduse if iduse== 	2608
replace cont=iduse if iduse== 	2617
replace cont=iduse if iduse== 	2628
replace cont=iduse if iduse== 	2637
replace cont=iduse if iduse== 	2660
replace cont=iduse if iduse== 	2686
replace cont=iduse if iduse== 	2716
replace cont=iduse if iduse== 	2719

bysort iduse: egen treated = max(treat)
tab sex if treated~=. | cont ~=.
/*1/4SDはPSによるが上のspecificationだと0.073641*/

gen group=.
replace group = 1 if treated ~=.
replace group = 0 if cont ~=.

stset lmonth if lmonth < 121, id(id) failure(quit==1)


sts graph if lmonth < 121, by(cc01leav) ciopts(cc01leav) level(95) title("A.調整前（N=293）") xtitle("勤続月数")  legend(order(2 1) label(1 "非取得") label(2 "取得")) saving(lcsobs.gph,replace)
sts graph if lmonth < 121, by(group) title("B.調整後（N=156）") xtitle("勤続月数")  legend(order(2 1) label(1 "非取得") label(2 "取得")) saving(lcsprop.gph,replace)
graph use lcsobs.gph
graph use lcsprop.gph
graph combine lcsobs.gph lcsprop.gph

sts list if group ~=., by(cc01leav) compare at (0 1 to 120)
sts list , by(cc01leav) compare at (0 1 to 120)
/*after mathing 3 11 for 10%, 29, 7 for 20%, 51 11 for 30%, 36 9 for 25*/
/*before matcing 3 13 for 10%, 32, 7 for 20%, 56 11 for 30%, 51 8 for 25*/
/*最初はそこまで差がないが、25%タイル付近では調整後の方が早く抜ける、したがって、調整前は上方バイアス？*/

stset lmonth, id(id) failure(quit==1)
stsum, by(cc01leav)
sts list , by(cc01leav) compare at (0 1 to 200)

cd "/Users/fumiyau/Desktop/JGSS_LCS_Submission/margins"
gen lmonth2=lmonth*lmonth/100
gen tenurex=tenure/12


/*分析では60ヶ月以内とする*/

/*表示用*/
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 60 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. , nolog noemptycells
est sto expl1
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 60 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. & group ~=., nolog noemptycells
est sto expl2
quietly esttab expl1 expl2 using lcs_reg_new.csv, se scalar(N ll aic r2_p) star(† 0.1 * 0.05 ** 0.01 *** 0.001) b(3)  replace label  wide  noomitted title(Exploration: Including Cases after 2011)

quietly logit quit c.lmonth##i.cc01leav c.lmonth##c.lmonth##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenure  if lmonth <= 60 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. , nolog noemptycells
quietly estpost margins cc01leav, at(lmonth=(0(1)60)) level(95) 
quietly esttab . using margins_obs.csv, replace r(b) label wide nostar
quietly logit quit c.lmonth##i.cc01leav c.lmonth##c.lmonth##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenure  if lmonth <= 60 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. & group ~=., nolog noemptycells
quietly estpost margins cc01leav, at(lmonth=(0(1)60)) level(95) 
quietly esttab . using margins_prop.csv, replace r(b) label wide nostar

/*120ヶ月*/
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. , nolog noemptycells
est sto expl1
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. & group ~=., nolog noemptycells
est sto expl2
quietly esttab expl1 expl2 using lcs_reg_120.csv, se scalar(N ll aic r2_p) star(† 0.1 * 0.05 ** 0.01 *** 0.001) b(3)  replace label  wide  noomitted title(Exploration: Including Cases after 2011)

quietly logit quit c.lmonth##i.cc01leav c.lmonth##c.lmonth##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenure  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. , nolog noemptycells
quietly estpost margins cc01leav, at(lmonth=(1(1)120))  
quietly esttab . using margins_obs120.csv, replace r(b) label wide nostar
quietly logit quit c.lmonth##i.cc01leav c.lmonth##c.lmonth##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenure  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. & group ~=., nolog noemptycells
quietly estpost margins cc01leav, at(lmonth=(1(1)120))  
quietly esttab . using margins_prop120.csv, replace r(b) label wide nostar

/*藤原ゼミ*/
/* Regression using pweights */
quietly logit cc01leav i.redu  i.spedu i.bch1 i.jobssm  i.type  i.szl i.pld tenure if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
predict pscore if  lmonth==1
bysort iduse: egen _pscore=max(pscore)
gen ipw=1/_pscore if cc01leav==1
replace ipw=1/(1-_pscore) if cc01leav==0

eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. , nolog noemptycells
est sto expl1
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. & group ~=., nolog noemptycells
est sto expl2
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex [pweight=ipw]  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=., nolog noemptycells
est sto expl3
quietly esttab expl1 expl2 expl3 using lcs_reg_120fjhr.csv, se scalar(N ll aic r2_p) star(† 0.1 * 0.05 ** 0.01 *** 0.001) b(3)  replace label  wide  noomitted title(Exploration: Including Cases after 2011)

quietly logit quit c.lmonth##i.cc01leav c.lmonth##c.lmonth##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenure [pweight=ipw]  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=., nolog noemptycells
quietly estpost margins cc01leav, at(lmonth=(1(1)120))  
quietly esttab . using margins_prop120fjhr.csv, replace r(b) label wide nostar



/*層別化とcox proportional*/
stset lmonth, id(id) failure(quit==1)
sort iduse
by iduse: egen blockid = max(myblock)

/*実際には1/4の非取得者が半年以内に退職しているので、これを考慮する。*/

stcox i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat i.cc01leav if blockid == 1
stcox i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat i.cc01leav if blockid == 2
stcox i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat i.cc01leav if blockid == 3
stcox i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat i.cc01leav if blockid == 4
stcox i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat i.cc01leav if blockid == 5
/*timi varyingでも時間依存ではない場合にはtvcに入れる必要はない*/
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 1
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 2
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 3
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 4
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 5
/*ただ、この手法だとハザード比が一定であるという過程を置いているのでそもそも長期的な効果を見る必要があったのか問題*/
stcox i.redu i.spedu i.jobssmre i.pld i.cc01leav if blockid == 1, tvc( tenure )
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 2
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 3
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 4
stcox i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 5


logit quit lmonth i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 1
logit quit lmonth i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 2
logit quit lmonth i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 3
logit quit lmonth i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 4
logit quit lmonth i.redu i.spedu i.jobssmre i.pld tenure i.cc01leav if blockid == 5
/*この後、ハザードを予測する。*/


/*記述的分析*/
/*記述統計 281ケース イベヒスの時にはしない*/

/*drop if redu ==. | spedu ==. | bch ==. | jobssm ==. | type ==. | szl ==. | pld ==. | tencat ==. | jobssm1 ==. | sz1 ==. |  type1 ==.
*/

tab redu if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
tab spedu if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= .
tab bch if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.  & timeen ~= . & timest ~= .
tab jobssm if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.  & timeen ~= . & timest ~= .
tab type if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.  & timeen ~= . & timest ~= .
tab szl if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.  & timeen ~= . & timest ~= .
tab pld if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.  & timeen ~= . & timest ~= .
tab tencat if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.  & timeen ~= . & timest ~= .

sort iduse
by iduse: egen maxlmonth = max(lmonth)


mean maxlmonth if length == cbirth1 & type ~=3, over(cc01leav)
mean maxlmonth if length == cbirth1 & type ~=3, over(redu)
mean maxlmonth if length == cbirth1 & type ~=3, over(spedu)
mean maxlmonth if length == cbirth1 & type ~=3, over(bch)
mean maxlmonth if length == cbirth1 & type ~=3, over(jobssm)
mean maxlmonth if length == cbirth1 & type ~=3, over(type)
mean maxlmonth if length == cbirth1 & type ~=3, over(szl)
mean maxlmonth if length == cbirth1 & type ~=3, over(pld)
mean maxlmonth if length == cbirth1 & type ~=3, over(tencat)


/*離散時間ロジットの用意*/
gen lmonth12 = lmonth >= 0 & lmonth <12
gen lmonth24 = lmonth >= 12 & lmonth <24
gen lmonth36 = lmonth >= 24 & lmonth <36
gen lmonth48 = lmonth >= 36 & lmonth <48
gen lmonth60 = lmonth >= 48 & lmonth <60
gen lmonth72 = lmonth >= 60 & lmonth <72
gen lmonth96 = lmonth >= 72 & lmonth <96
gen lmonth120 = lmonth >= 96 & lmonth <120
gen lmonth180 = lmonth >= 120 & lmonth <180
gen lmonth240 = lmonth >= 180 & lmonth <240
gen lmonth360 = lmonth >= 240

/*育児休暇を取得した企業でどれくらい継続するのか*/
/*サンプルは第一子を出産した人*/
/*cbirth1のタイミングが含まれる職業*/

/*育児休暇取得かどうかの勤続期間*/
stset lmonth, failure(quit==1) id(id)

sts graph if cbirth1 ~=. & sex == 2 &  type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=., by(cc01leav) ixlabel

sts graph if cbirth1 ~=. & sex == 2, by(redu)

sts graph if type ~=3, by(cc01leav) legend(label(1 "非取得") label(2 "取得"))
sts graph if type ~=3, by(type) legend(label(1 "正規") label(2 "非正規"))

gen typem = type if cbirth1 == length
sort iduse
by iduse: egen type_cbirth = max(typem)
sts graph if type_cbirth ~=3, by(type) legend(label(1 "出産時正規") label(2 "出産時非正規"))

tab redu if length == cbirth1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.

/*企業規模の効果が育休取得によって消えるかを確認する*/
/*麦さんのコメントを参考に、時間の長さを強調した構成にする*/
/*カテゴリ値の作成*/
gen lmcat = lmonth
gen loglmonth =log(lmonth)
recode lmcat (0/3=1)(4/6=2)(7/12=2)(13/24=3)(24/36=4)(36/60=5)(60/96=6)(97/240=7)
logit quit  c.loglmonth##i.cc01leav i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat if type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=.
margins cc01leav, at(loglmonth=(0(0.1)5.463832))

logit quit i.lmcat##i.cc01leav i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.cc01leav i.tencat if type ~=3
margins cc01leav, at(lmcat=(1(1)7))
recode jobssm 2=0

qui logit quit lmonth i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat  if type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=.
est sto disc1
qui logit quit lmonth i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat i.cc01leav if type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=.
est sto disc2
qui logit quit lmonth i.redu i.spedu i.jobssm i.type i.szl i.pld i.bch1 i.tencat i.cc01leav c.lmonth##i.cc01leav if type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=.
est sto disc3
esttab disc1 disc2 disc3 using result_disc.csv, wide se r2 star(* 0.1 ** 0.05 *** 0.01) b(3)  label  replace noomitted title()

margins cc01leav, at(lmonth=(0(5)230))
marginsplot, xtitle(出産後勤続月数 ) ytitle(Pr(quit))  noci title(モデル3から予測される育児休業取得と出産後勤続月数の交互作用)  legend(order(1 "非取得" 2 "取得") ring(0) pos(2) col(1))


/*A出産時無職を含むmodel 1-5
qui logit cc01leav i.redu i.spedu i.bch1 if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=. 
est sto reg1
qui logit cc01leav i.redu i.spedu i.bch1 i.ump i.jobssm1 i.type1 if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=.
est sto reg2
qui logit cc01leav i.redu i.spedu i.bch1 i.ump i.jobssm1 i.type1 i.sz1 if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=.
est sto reg3
qui logit cc01leav i.redu i.spedu i.bch1 i.ump i.jobssm1 i.type1 i.sz1 i.tencat if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=.
est sto reg4
qui logit cc01leav i.redu i.spedu i.bch1 i.ump i.jobssm1 i.type1 i.sz1 i.tencat i.pld if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=.
est sto reg5
qui logit cc01leav i.redu i.spedu i.bch1 i.ump i.jobssm1 i.type1 i.sz1 tenlog i.pld if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=.
est sto reg7

esttab reg1 reg2 reg3 reg4 reg5 reg7 using result.tex, se r2 star(* 0.1 ** 0.05 *** 0.01) b(3)  replace

/*B出産時無職を含まないmodel 1-6出産時無業除く*/ 
qui logit cc01leav i.redu i.spedu i.bch1 if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=. & szl ~= 10
est sto regs1
qui logit cc01leav i.redu i.spedu i.bch1  i.jobssm i.type if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=. & szl ~= 10
est sto regs2
qui logit cc01leav i.redu i.spedu i.bch1  i.jobssm i.type i.szl if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=. & szl ~= 10
est sto regs3
qui logit cc01leav i.redu i.spedu i.bch1  i.jobssm i.type i.szl i.tencat if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=. & szl ~= 10
est sto regs4
qui logit cc01leav i.redu i.spedu i.bch1  i.jobssm i.type i.szl i.tencat i.pld if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=. & szl ~= 10
est sto regs5
qui logit cc01leav i.redu i.spedu i.bch1  i.jobssm i.type i.szl tenlog i.pld if cbirth1 == length & sex == 2 & cc01leav ~=. & szl ~=. & jobssm ~=. & type ~=. & redu ~=. & spedu ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & type1 ~=. & sz1 ~=. & szl ~= 10
est sto regs6

esttab regs1 regs2 regs3 regs4 regs5 regs6 using result.tex, se r2 star(* 0.1 ** 0.05 *** 0.01) b(3)  replace
http://baserv.uci.kun.nl/-johnh/rnIogistiologit.htrnI.　*/
/*分析から自営を抜く*/

