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
