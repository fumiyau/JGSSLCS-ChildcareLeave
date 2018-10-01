use "/Users/fumiyau/Desktop/JGSS_LCS_Submission/Data/JGSS_LCS.dta", clear
/*出生年は1966年から1980年*/
/* reshape用データ加工, Difine id, age, sex */
gen id=_n
gen age = ageb 
gen sex = sexa 

/* 職歴段数 */
/* 従業先番号:10以上は存在しない*/
/* 仕事開始年齢:1982年を基準とした月数で計算する。*/
/*入職月数が不明の場合4を代入する。*/
forvalues i=1/9{
rename job0`i' noj`i'
recode jb0`i'sty 8888=. 9999=.
recode jb0`i'stm 88=. 99=.
replace jb0`i'stm = 4 if jb0`i'sty ~=. & jb0`i'stm ==.
replace jb0`i'sty = (jb0`i'sty - 1982)*12
gen jobst`i' = jb0`i'sty + jb0`i'stm
}

gen beginjob = jobst1

gen begin16 = (dobyear+16-1982)*12
recode spagex 999=.
replace begin16=(2009-spagex+16-1982)*12 if sex == 1

/* 仕事終了年齢 */
/*離職月数が不明の場合3を代入する。*/
/*仕事継続している場合は326ヶ月目でやめたという構成*/
forvalues i=1/9{
recode jb0`i'eny 8888=. 9999=.
recode jb0`i'enm 88=. 99=.
replace jb0`i'enm = 3 if jb0`i'eny ~=. & jb0`i'enm ==.
replace jb0`i'eny = (jb0`i'eny - 1982)*12
gen joben`i' = jb0`i'eny + jb0`i'enm
replace joben`i' = 326 if jb0`i'ong == 2
}
drop if joben1 ==. 

/*子供出生年：同じく1982年を基準とした月数に換算*/
forvalues i=1/5{
rename cc0`i'byr cby`i'
recode cby`i' 8888=. 9999=.
replace cby`i' = (cby`i'-1982)*12
rename cc0`i'bm cbm`i'
recode cbm`i' 88=. 99=.
gen cbirth`i' = cby`i' + cbm`i'
}

/* 10回以上転職は削除 */
drop if job10wpl ~= .a

/* 事業内容/従業員数 */
forvalues i=1/9{
rename job0`i'wpl wpl`i'
rename job0`i'sz sz`i'
recode sz`i' 99=.
}

/* 結婚先番号 */
rename mrg0* mrg*
/* 結婚開始年齢 */
forvalues i=1/2{
recode mrg`i'sty 8888=. 9999=.
recode mrg`i'stm 88=. 99=.
replace mrg`i'sty = (mrg`i'sty - 1982)*12
gen mrgst`i' = mrg`i'sty + mrg`i'stm
recode mrg`i'eny 8888=. 9999=.
recode mrg`i'enm 88=. 99=.
replace mrg`i'eny = (mrg`i'eny - 1982)*12
gen mrgen`i' = mrg`i'eny + mrg`i'enm
}
gen pastdiv = mrg2
recode pastdiv 2=0

/*初婚が婚前妊娠*/
gen bripreg=0
recode bripreg 0=. if ccnumttl==0 | ccnumttl==.
recode bripreg 0=1 if cbirth1< mrgst1+9 & mrgst1~=. & cbirth1~=.

gen ccnum1 = ccnumttl
recode ccnum1 1/7=1

gen ccnum2 = ccnumttl
recode ccnum2 0/1=0 2/7=1

gen ccnum3 = ccnumttl
recode ccnum3 0/2=0 3/7=1

/* 学歴（1中学卒 2高校卒 3その他（専門など）4短大卒  5大学以上*/
gen redu = 0
recode redu 0=1 if schtpno == 1
recode redu 0=2 if schtphs == 1 & schtpvs == 0 & schtpunv == 0 & schtpot == 0 & schtpgs == 0 & schtpct == 0 & schtp2yc == 0 & schtpno == 0
recode redu 0=4 if schtphs == 1 & schtpvs == 0 & schtpunv == 0 & schtpot == 0 & schtpgs == 0 & schtpct == 0 & schtp2yc == 1 & schtpno == 0
recode redu 0=5 if schtphs == 1 & schtpunv == 1 & schtpgs == 0 & schtpno == 0
recode redu 0=5 if schtphs == 1 & schtpunv == 1 & schtpgs == 1 & schtpno == 0
recode redu 0=3

/*配偶者学歴（1中学卒 2高校卒 3その他（専門など）4短大卒  5大学以上*/
gen spedu = 0
replace spedu = 3 if pspsch == 1
replace spedu = sslstsch if spedu == 0
recode spedu 6=5 
recode spedu 7/9=.
drop if redu==.
drop if spedu==.
recode redu spedu (1/2=1)(3/4=2)(5=3)

gen marriage = domarry
recode marriage 5=1 6=2 3=2 4=3

gen nowdiv=marriage
recode nowdiv 1=0 3=0 2=1

gen cnum=ccnumttl
recode cnum (4/7=4)

drop if marriage == 3

/*職種（職業→SSM8分類）*/
/* SSM 8 classification (including no-job) */
/* 1"専門" 2"管理" 3"事務" 4"販売" 5"熟練" 6"半熟練" 7"非熟練" 8"農林" 9"無職"*/
/*追加コードの分類について
701"スーパーなどのレジスター係員、キャッシャー" = 4
702"大工" = 5
703"教員" = 2
704"製品製造作業者（製品不明）" = 7
705"会社員" = .
706"宅配便の配達" = 8
707"自営業" = .
801"ヘルパー" = 4
802"その他の医療・福祉サービス職従事者" = 4
803"雇われている販売店長" = 4
804"雇われている飲食店長" = 4
*/
/*下から2つめの行は150712class_analysis.doから取ってきた*/
/*従業上の地位（雇用形態）*/
/*職業威信スコアSSM1995年版*/
forvalues i=1/9{
gen jobssm`i' = jb0`i's0oc 
recode jobssm`i' (501/544 = 1)(609/610 = 1)(615 = 1)(703 = 1) (545/553 = 2)(608 = 2)(554/565 = 3)(586 = 3)(590 = 3)(593/598 = 3)(616/619 = 3)(701 = 3) (566/577 = 4)(582/585 = 4)(587/589 = 4) (579 = 5)(581 = 5)(623/624 = 5)(626 = 5)(628 = 5)(631 = 5)(633 = 5)(635/644 = 5)(647 = 5)(651 = 5)(654/656 = 5)(658 = 5)(660/666= 5)(668 = 5)(670/675 = 5)(677/681 = 5)(684 = 5)(702 = 5) (580 = 6)(606/607 = 6)(611/614 = 6)(625 = 6)(627 = 6)(629/630 = 6)(632 = 6)(634 = 6)(645/646 = 6)(648/650 = 6)(652/653 = 6)(657 = 6)(659 = 6)(667 = 6)(669 = 6)(672 = 6)(676 = 6)(704 = 6)(706=6) (578 = 7)(591/592 = 7)(620/622 = 7)(682/683 = 7)(685/688 = 7)(599/605 = 8)(998 =9)(689 =.)(987 =.)(999 =.)(988=.)(701 = 4)(702 = 5)(703 = 2)(704 = 7)(705 =.)(706 = 8)(707 =.)(801 = 4)(802 = 4)(803 = 4)(804 = 4)
rename jb0`i's0tp type`i'
recode type`i' (8=.) (99=.) 
gen jobpres`i' = jb0`i's0oc 
}

/*出生コーホート*/
gen cohort = dobyear
recode cohort 1966/1970 = 1 1971/1975=2 1976/1980=3

/*親との同居期間*/
recode plv01jh 8=. 9=.
forvalues i=1/4{
recode plv0`i'sty 8888=. 9999=.
recode plv0`i'eny 8888=. 9999=.
recode plv0`i'stm 88=. 99=.
recode plv0`i'enm 88=. 99=.
gen plsty`i' = plv0`i'sty
}

/*1966年生まれで15歳以前に離家している人はマイナスになる*/
replace plsty1 = (((2009 - age) + 15)-1982)*12 if plv01jh == 2
replace plsty1 = (plv01sty-1982)*12 if plv01jh == 1
replace plsty2 = (plv02sty-1982)*12
replace plsty3 = (plv03sty-1982)*12
replace plsty4 = (plv04sty-1982)*12

forvalues i=1/4{
gen pleny`i' = plv0`i'eny
replace pleny`i' = (plv0`i'eny-1982)*12 
recode plv0`i'ong 8=. 9=.
replace pleny`i' = 326 if plv0`i'ong == 2
}

/*出生年コホート*/
forvalues i=1/3{
gen bch`i' = (cby`i'/12)+1982
recode bch`i' 1986/1991=1 1992/1994=2 1995/2001=3 2002/2004=4 2005/2009=5
}

/*変数削除*/
drop psncns cnsdbcar cnsdbmcy cnsdbftv cnsdbdry cnsdbstk cnsdbno exrsmeal exrshous exrsutl exrsclth exrscomm exrsmed exrsedu exrsent exrsot exrsno exwtfood exwthous exwtappl exwtcar exwtfshn exwtlssn exwtfrd exwttrav exwtsprt exwtsmc exwthk exwtedu exwtpet exwtot exwtno jhclbphy jhclbcul
drop cndflx cndsmpr cndsmamt cndsmhdy cndjnt cndunrst cndins cndspt cndknlg cndtrn cndrep cndabl cndeft cndacmp cndwrth cndblc cowkamt cowkidea cowkspt skscdoc sksceng sksccoop skscintv skscvers sksclead skscmnnr  skscrcpt skscchrc skscsoc sksclaw skscrght skscno skwkdoc skwkeng skwkcoop skwkintv skwkvers skwklead skwkmnnr skwkrcpt skwkchrc skwksoc skwklaw skwkrght skwkno skwknw skwtdoc skwteng skwtcoop skwtintv skwtvers  skwtlead skwtmnnr skwtrcpt skwtchrc skwtsoc skwtlaw skwtrght skwtno tmalwk tmalhby tmalfam tmalhw
drop hrtv fq5read fq5comic docompj docompp dophs dononex doinbrs doinshop doinbank doinhpb doinpic doinbbs doincs doinnone fq6email netfrnd comabprg comabset comabins comabgr comabdoc comabno opplnet menhlnrv menhlclm menhldp menhlpls menhldwn xtraum5y st5areay st5leisy st5lifey st5ecny st5friy st5hlthy st5ssrel op5happz arbptjb xworkl
drop tpjob tpjobp tpjsfam tpjsfrd tpjswk tpjsrec tpjsoff tpjsweb tpjsad tpjspub tpjsprv tpjspt tpjsfb tpjsnew tpjsot tpjsdk tpjsapot
drop jb01sjno jb01sjdp jb01sjpt jb01sjfb jb01sjot jb02sjno jb02sjdp jb02sjpt jb02sjfb jb02sjot jb03sjno jb03sjdp jb03sjpt jb03sjfb jb03sjot jb04sjno jb04sjdp jb04sjpt jb04sjfb jb04sjot jb05sjno jb05sjdp jb05sjpt  jb05sjfb jb05sjot jb06sjno jb06sjdp jb06sjpt jb06sjfb jb06sjot jb07sjno jb07sjdp jb07sjpt jb07sjfb jb07sjot jb08sjno jb08sjdp jb08sjpt jb08sjfb jb08sjot jb09sjno jb09sjdp jb09sjpt jb09sjfb jb09sjot jb10sjno jb10sjdp jb10sjpt jb10sjfb jb10sjot jb11sjno jb11sjdp jb11sjpt jb11sjfb jb11sjot jb12sjno jb12sjdp jb12sjpt jb12sjfb jb12sjot jb13sjno jb13sjdp jb13sjpt jb13sjfb jb13sjot jb14sjno jb14sjdp jb14sjpt jb14sjfb jb14sjot jb15sjno jb15sjdp jb15sjpt jb15sjfb jb15sjot jb16sjno jb16sjdp jb16sjpt jb16sjfb jb16sjot jb17sjno jb17sjdp jb17sjpt jb17sjfb jb17sjot jb18sjno jb18sjdp jb18sjpt jb18sjfb jb18sjot jb19sjno jb19sjdp jb19sjpt jb19sjfb jb19sjot jb20sjno jb20sjdp jb20sjpt jb20sjfb jb20sjot
drop jb10sty jb10stm jb10ong jb10eny jb10enm jb11sty jb11stm jb11ong jb11eny jb11enm jb12sty jb12stm jb12ong jb12eny jb12enm jb13sty jb13stm jb13ong jb13eny jb13enm jb14sty jb14stm jb14ong jb14eny jb14enm jb15sty jb15stm jb15ong jb15eny jb15enm jb16sty jb16stm jb16ong jb16eny jb16enm jb17sty jb17stm jb17ong jb17eny jb17enm jb18sty jb18stm jb18ong jb18eny jb18enm jb19sty jb19stm jb19ong jb19eny jb19enm jb10s0tp jb10s0tl jb10s0oc jb10s1 jb10s1tp jb10s1tl jb10s1oc jb10s1y jb10s1m jb10s2 jb10s2tp jb10s2tl jb10s2oc jb10s2y jb10s2m jb10s3 jb10s3tp jb10s3tl jb10s3oc jb10s3y jb10s3m jb10s4 jb10s4tp jb10s4tl jb10s4oc jb10s4y jb10s4m jb11s0tp jb11s0tl jb11s0oc jb11s1 jb11s1tp jb11s1tl jb11s1oc jb11s1y jb11s1m jb11s2 jb11s2tp jb11s2tl jb11s2oc jb11s2y jb11s2m jb11s3 jb11s3tp jb11s3tl jb11s3oc jb11s3y jb11s3m jb11s4 jb11s4tp jb11s4tl jb11s4oc jb11s4y jb11s4m jb12s0tp jb12s0tl jb12s0oc jb12s1 jb12s1tp jb12s1tl jb12s1oc jb12s1y jb12s1m jb12s2 jb12s2tp jb12s2tl jb12s2oc jb12s2y jb12s2m jb12s3 jb12s3tp jb12s3tl jb12s3oc jb12s3y jb12s3m jb12s4 jb12s4tp jb12s4tl jb12s4oc jb12s4y jb12s4m jb13s0tp jb13s0tl jb13s0oc jb13s1 jb13s1tp jb13s1tl jb13s1oc jb13s1y jb13s1m jb13s2 jb13s2tp jb13s2tl jb13s2oc jb13s2y jb13s2m jb13s3 jb13s3tp jb13s3tl jb13s3oc jb13s3y jb13s3m jb13s4 jb13s4tp jb13s4tl jb13s4oc jb13s4y jb13s4m jb14s0tp jb14s0tl jb14s0oc jb14s1 jb14s1tp jb14s1tl jb14s1oc jb14s1y jb14s1m jb14s2 jb14s2tp jb14s2tl jb14s2oc jb14s2y jb14s2m jb14s3 jb14s3tp jb14s3tl jb14s3oc jb14s3y jb14s3m jb14s4 jb14s4tp jb14s4tl jb14s4oc jb14s4y jb14s4m jb15s0tp jb15s0tl jb15s0oc jb15s1 jb15s1tp jb15s1tl jb15s1oc jb15s1y jb15s1m jb15s2 jb15s2tp jb15s2tl jb15s2oc jb15s2y jb15s2m jb15s3 jb15s3tp jb15s3tl jb15s3oc jb15s3y jb15s3m jb15s4 jb15s4tp jb15s4tl jb15s4oc jb15s4y jb15s4m jb16s0tp jb16s0tl jb16s0oc jb16s1 jb16s1tp jb16s1tl jb16s1oc jb16s1y jb16s1m jb16s2 jb16s2tp jb16s2tl jb16s2oc jb16s2y jb16s2m jb16s3 jb16s3tp jb16s3tl jb16s3oc jb16s3y jb16s3m jb16s4 jb16s4tp jb16s4tl jb16s4oc jb16s4y jb16s4m jb17s0tp jb17s0tl jb17s0oc jb17s1 jb17s1tp jb17s1tl jb17s1oc jb17s1y jb17s1m jb17s2 jb17s2tp jb17s2tl jb17s2oc jb17s2y jb17s2m jb17s3 jb17s3tp jb17s3tl jb17s3oc jb17s3y jb17s3m jb17s4 jb17s4tp jb17s4tl jb17s4oc jb17s4y jb17s4m jb18s0tp jb18s0tl jb18s0oc jb18s1 jb18s1tp jb18s1tl jb18s1oc jb18s1y jb18s1m jb18s2 jb18s2tp jb18s2tl jb18s2oc jb18s2y jb18s2m jb18s3 jb18s3tp jb18s3tl jb18s3oc jb18s3y jb18s3m jb18s4 jb18s4tp jb18s4tl jb18s4oc jb18s4y jb18s4m jb19s0tp jb19s0tl jb19s0oc jb19s1 jb19s1tp jb19s1tl jb19s1oc jb19s1y jb19s1m jb19s2 jb19s2tp jb19s2tl jb19s2oc jb19s2y jb19s2m jb19s3 jb19s3tp jb19s3tl jb19s3oc jb19s3y jb19s3m jb19s4 jb19s4tp jb19s4tl jb19s4oc jb19s4y jb19s4m 

/***lengthを使ってパーソンピリオドの作成***/
/*drop if id == 736*/
/* 定職ダミー1（辞めた月から無職と考える）*/
/* 初職開始月数から計算 501,975レコードの作成*/
gen tf = 326 - begin16 + 1
expand tf
sort id 
by id: gen length = begin16 + _n - 1
sort iduse
by iduse: egen maxlength = max(length)

gen jobstst = 1
recode jobstst 1 =0 if length >= joben1 & jobst2 > length  & joben1 ~= jobst2 & joben1 ~=. & jobst2 ~=.
recode jobstst 1 =0 if length >= joben2 & jobst3 > length  & joben2 ~= jobst3 & joben2 ~=. & jobst3 ~=.
recode jobstst 1 =0 if length >= joben3 & jobst4 > length  & joben3 ~= jobst4 & joben3 ~=. & jobst4 ~=.
recode jobstst 1 =0 if length >= joben4 & jobst5 > length  & joben4 ~= jobst5 & joben4 ~=. & jobst5 ~=.
recode jobstst 1 =0 if length >= joben5 & jobst6 > length  & joben5 ~= jobst6 & joben5 ~=. & jobst6 ~=.
recode jobstst 1 =0 if length >= joben6 & jobst7 > length  & joben6 ~= jobst7 & joben6 ~=. & jobst7 ~=.
recode jobstst 1 =0 if length >= joben7 & jobst8 > length  & joben7 ~= jobst8 & joben7 ~=. & jobst8 ~=.
recode jobstst 1 =0 if length >= joben8 & jobst9 > length  & joben8 ~= jobst9 & joben8 ~=. & jobst9 ~=.
 
/* 定職ダミー2（辞めた月の一ヶ月後から無職と考える）→こちらを基本的に採用する*/
gen jobstst2 = 0
recode jobstst2 0=1 if jobst1 <= length & length <= joben1 & joben1 ~=. & jobst1 ~=. 
recode jobstst2 0=1 if jobst2 <= length & length <= joben2 & joben2 ~=. & jobst2 ~=.
recode jobstst2 0=1 if jobst3 <= length & length <= joben3 & joben3 ~=. & jobst3 ~=.
recode jobstst2 0=1 if jobst4 <= length & length <= joben4 & joben4 ~=. & jobst4 ~=.
recode jobstst2 0=1 if jobst5 <= length & length <= joben5 & joben5 ~=. & jobst5 ~=.
recode jobstst2 0=1 if jobst6 <= length & length <= joben6 & joben6 ~=. & jobst6 ~=.
recode jobstst2 0=1 if jobst7 <= length & length <= joben7 & joben7 ~=. & jobst7 ~=.
recode jobstst2 0=1 if jobst8 <= length & length <= joben8 & joben8 ~=. & jobst8 ~=.
recode jobstst2 0=1 if jobst9 <= length & length <= joben9 & joben9 ~=. & jobst9 ~=.

gen pld = 0
recode pld 0=1 if plsty1 <= length & length <= pleny1 & plsty1 ~=. & pleny1 ~=.
recode pld 0=1 if plsty2 <= length & length <= pleny2 & plsty1 ~=. & pleny1 ~=.
recode pld 0=1 if plsty3 <= length & length <= pleny3 & plsty1 ~=. & pleny1 ~=.
recode pld 0=1 if plsty4 <= length & length <= pleny4 & plsty1 ~=. & pleny1 ~=.
 
/*在職期間*/
bysort id: gen tenure1 = length - jobst1 + 1 if jobstst2 == 1 & joben1 >= length & jobst1 <= length & joben1 ~=. & jobst1 ~=. 
bysort id: gen tenure2 = length - jobst2  if jobstst2 == 1 & joben2 >= length & jobst2 < length & joben2 ~=. & jobst2 ~=. 
bysort id: gen tenure3 = length - jobst3  if jobstst2 == 1 & joben3 >= length & jobst3 < length & joben3 ~=. & jobst3 ~=. 
bysort id: gen tenure4 = length - jobst4  if jobstst2 == 1 & joben4 >= length & jobst4 < length & joben4 ~=. & jobst4 ~=. 
bysort id: gen tenure5 = length - jobst5  if jobstst2 == 1 & joben5 >= length & jobst5 < length & joben5 ~=. & jobst5 ~=. 
bysort id: gen tenure6 = length - jobst6  if jobstst2 == 1 & joben6 >= length & jobst6 < length & joben6 ~=. & jobst6 ~=. 
bysort id: gen tenure7 = length - jobst7  if jobstst2 == 1 & joben7 >= length & jobst7 < length & joben7 ~=. & jobst7 ~=. 
bysort id: gen tenure8 = length - jobst8  if jobstst2 == 1 & joben8 >= length & jobst8 < length & joben8 ~=. & jobst8 ~=. 
bysort id: gen tenure9 = length - jobst9  if jobstst2 == 1 & joben9 >= length & jobst9 < length & joben9 ~=. & jobst9 ~=. 

gen tenure = .
replace tenure = tenure1 if jobstst2 == 1 & joben1 >= length & jobst1 <= length & joben1 ~=. & jobst1 ~=.  
replace tenure = tenure2 if jobstst2 == 1 & joben2 >= length & jobst2 < length  & joben2 ~=. & jobst2 ~=. 
replace tenure = tenure3 if jobstst2 == 1 & joben3 >= length & jobst3 < length  & joben3 ~=. & jobst3 ~=. 
replace tenure = tenure4 if jobstst2 == 1 & joben4 >= length & jobst4 < length  & joben4 ~=. & jobst4 ~=. 
replace tenure = tenure5 if jobstst2 == 1 & joben5 >= length & jobst5 < length  & joben5 ~=. & jobst5 ~=. 
replace tenure = tenure6 if jobstst2 == 1 & joben6 >= length & jobst6 < length  & joben6 ~=. & jobst6 ~=. 
replace tenure = tenure7 if jobstst2 == 1 & joben7 >= length & jobst7 < length  & joben7 ~=. & jobst7 ~=. 
replace tenure = tenure8 if jobstst2 == 1 & joben8 >= length & jobst8 < length  & joben8 ~=. & jobst8 ~=. 
replace tenure = tenure9 if jobstst2 == 1 & joben9 >= length & jobst9 < length  & joben9 ~=. & jobst9 ~=. 
 
/*在職期間カテゴリ（1 1年以内 2 2-3年以内 3 4-5年以内 4 6-10年以内 5 11年以上）*/
gen tencat = tenure 
recode tencat 1/12=1 13/36=2 37/60 = 3 61/120=4 121/311=5
recode tencat .=1

/* 従業員数 */
gen szl = 0
replace szl = sz1 if jobstst2 == 1 & jobst1 <= length & length <= joben1 & joben1 ~=. & jobst1 ~=. 
replace szl = sz2 if jobstst2 == 1 & jobst2 < length & length <= joben2 & joben2 ~=. & jobst2 ~=. 
replace szl = sz3 if jobstst2 == 1 & jobst3 < length & length <= joben3 & joben3 ~=. & jobst3 ~=. 
replace szl = sz4 if jobstst2 == 1 & jobst4 < length & length <= joben4 & joben4 ~=. & jobst4 ~=. 
replace szl = sz5 if jobstst2 == 1 & jobst5 < length & length <= joben5 & joben5 ~=. & jobst5 ~=. 
replace szl = sz6 if jobstst2 == 1 & jobst6 < length & length <= joben6 & joben6 ~=. & jobst6 ~=. 
replace szl = sz7 if jobstst2 == 1 & jobst7 < length & length <= joben7 & joben7 ~=. & jobst7 ~=. 
replace szl = sz8 if jobstst2 == 1 & jobst8 < length & length <= joben8 & joben8 ~=. & jobst8 ~=. 
replace szl = sz9 if jobstst2 == 1 & jobst9 < length & length <= joben9 & joben9 ~=. & jobst9 ~=. 

/* 事業内容 */
gen wpllx = 0
replace wpllx = wpl1 if jobstst2 == 1 & jobst1 <= length & length <= joben1
replace wpllx = wpl2 if jobstst2 == 1 & jobst2 < length & length <= joben2
replace wpllx = wpl3 if jobstst2 == 1 & jobst3 < length & length <= joben3
replace wpllx = wpl4 if jobstst2 == 1 & jobst4 < length & length <= joben4
replace wpllx = wpl5 if jobstst2 == 1 & jobst5 < length & length <= joben5
replace wpllx = wpl6 if jobstst2 == 1 & jobst6 < length & length <= joben6
replace wpllx = wpl7 if jobstst2 == 1 & jobst7 < length & length <= joben7
replace wpllx = wpl8 if jobstst2 == 1 & jobst8 < length & length <= joben8
replace wpllx = wpl9 if jobstst2 == 1 & jobst9 < length & length <= joben9

gen wpll = 0
replace wpll = wpl1 if jobstst2 == 1 & jobst1 <= length & length <= joben1 & joben1 ~=. & jobst1 ~=. 
replace wpll = wpl2 if jobstst2 == 1 & jobst2 < length & length <= joben2 & joben2 ~=. & jobst2 ~=. 
replace wpll = wpl3 if jobstst2 == 1 & jobst3 < length & length <= joben3 & joben3 ~=. & jobst3 ~=. 
replace wpll = wpl4 if jobstst2 == 1 & jobst4 < length & length <= joben4 & joben4 ~=. & jobst4 ~=. 
replace wpll = wpl5 if jobstst2 == 1 & jobst5 < length & length <= joben5 & joben5 ~=. & jobst5 ~=. 
replace wpll = wpl6 if jobstst2 == 1 & jobst6 < length & length <= joben6 & joben6 ~=. & jobst6 ~=. 
replace wpll = wpl7 if jobstst2 == 1 & jobst7 < length & length <= joben7 & joben7 ~=. & jobst7 ~=. 
replace wpll = wpl8 if jobstst2 == 1 & jobst8 < length & length <= joben8 & joben8 ~=. & jobst8 ~=. 
replace wpll = wpl9 if jobstst2 == 1 & jobst9 < length & length <= joben9 & joben9 ~=. & jobst9 ~=. 

/*雇用形態*/
gen typex = 0
replace typex = type1 if jobstst2 == 1 & jobst1 <= length & length <= joben1 & joben1 ~=. & jobst1 ~=. 
replace typex = type2 if jobstst2 == 1 & jobst2 < length & length <= joben2  & joben2 ~=. & jobst2 ~=. 
replace typex = type3 if jobstst2 == 1 & jobst3 < length & length <= joben3  & joben3 ~=. & jobst3 ~=. 
replace typex = type4 if jobstst2 == 1 & jobst4 < length & length <= joben4  & joben4 ~=. & jobst4 ~=. 
replace typex = type5 if jobstst2 == 1 & jobst5 < length & length <= joben5  & joben5 ~=. & jobst5 ~=. 
replace typex = type6 if jobstst2 == 1 & jobst6 < length & length <= joben6  & joben6 ~=. & jobst6 ~=. 
replace typex = type7 if jobstst2 == 1 & jobst7 < length & length <= joben7  & joben7 ~=. & jobst7 ~=. 
replace typex = type8 if jobstst2 == 1 & jobst8 < length & length <= joben8  & joben8 ~=. & jobst8 ~=. 
replace typex = type9 if jobstst2 == 1 & jobst9 < length & length <= joben9  & joben9 ~=. & jobst9 ~=. 

gen type = 0
replace type = type1 if jobstst2 == 1 & jobst1 <= length & length <= joben1
replace type = type2 if jobstst2 == 1 & jobst2 < length & length <= joben2
replace type = type3 if jobstst2 == 1 & jobst3 < length & length <= joben3
replace type = type4 if jobstst2 == 1 & jobst4 < length & length <= joben4
replace type = type5 if jobstst2 == 1 & jobst5 < length & length <= joben5
replace type = type6 if jobstst2 == 1 & jobst6 < length & length <= joben6
replace type = type7 if jobstst2 == 1 & jobst7 < length & length <= joben7
replace type = type8 if jobstst2 == 1 & jobst8 < length & length <= joben8
replace type = type9 if jobstst2 == 1 & jobst9 < length & length <= joben9 

gen jobssm = 0
replace jobssm = jobssm1 if jobstst2 == 1 & jobst1 <= length & length <= joben1
replace jobssm = jobssm2 if jobstst2 == 1 & jobst2 < length & length <= joben2
replace jobssm = jobssm3 if jobstst2 == 1 & jobst3 < length & length <= joben3
replace jobssm = jobssm4 if jobstst2 == 1 & jobst4 < length & length <= joben4
replace jobssm = jobssm5 if jobstst2 == 1 & jobst5 < length & length <= joben5
replace jobssm = jobssm6 if jobstst2 == 1 & jobst6 < length & length <= joben6
replace jobssm = jobssm7 if jobstst2 == 1 & jobst7 < length & length <= joben7
replace jobssm = jobssm8 if jobstst2 == 1 & jobst8 < length & length <= joben8
replace jobssm = jobssm9 if jobstst2 == 1 & jobst9 < length & length <= joben9 
 
gen mrgstst = 0
recode mrgstst 0=1 if mrgst1 <= length & length <= mrgen1 
recode mrgstst 0=1 if mrgst2 <= length & length <= mrgen2

gen bch=bch1 if cbirth1 == length
replace bch=bch2 if cbirth2 == length
replace bch=bch3 if cbirth3 == length

/*再コード1"専門管理"2"事務"3"販売"4"熟練"5"半非熟練"6"無職"*/
recode cc01leav 2=0 8=. 9=.
recode cc02leav 2=0 8=. 9=.
recode cc03leav 2=0 8=. 9=.
gen ccleav=cc01leav
replace ccleav=cc02leav if  cbirth2 == length 
replace ccleav=cc03leav if  cbirth3 == length 
gen cbex=.
forvalues i=1/3{
replace cbex=`i' if cbirth`i' == length 
}

recode type (1/2=1) (3/5=2) (6/7=3) (0=4)
recode type1 (1/2=1) (3/5=2) (6/7=3) (0=4)
recode szl (1/4=1) (5=2) (6=3) (7/9=4) (10/11=5) (12=6) (13=7) (88=.) (99=.) (0=10)
recode sz1 (1/4=1) (5=2) (6=3) (7/9=4) (10/11=5) (12=6) (13=7) (88=.) (99=.) (0=10)

/*有業コード*/
gen ump = 0
recode ump 0=1 if szl ~= 10

/*育児休暇を取得した企業でどれくらい継続するのか*/
/*サンプルは第一子を出産した人*/
/*cbirth1のタイミングが含まれる職業*/
gen timest = .
gen timeen = .
forvalues i=1/9{
replace timest = jobst`i'  if jobst`i' < cbirth1 & cbirth1 < joben`i'
replace timeen = joben`i'  if jobst`i' < cbirth1 & cbirth1 < joben`i'
}

/*timeenは子どもを在職中に産んだ人に限定しているため、quitが意味するのは、子どもを在職中に産んだ人が仕事を辞めたかどうか*/
recode spedu .a=4
recode ump 1=0 if timeen == . | timest == .
recode szl sz1 (.=7)
drop if sex ==1
drop if cc01leav ==.
/*heckprobitのために在職前に子供を産んでやめた人を分析から除外しない。*/
/*gen lmonth = length - beginjob*/
recode jobssm* (1/2=1)(3=2)(4=3)(5/8=4)(9=.)
save "JGSS_LCS0824.dta", replace
*file size: 759.9 MB
