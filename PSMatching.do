/*1to1 matchを行う。その上で、マッチされたサンプル同士で比較*/
/*Nearest neibor within caliper 0.1 採用*/
set seed 1000
generate x=uniform()
sort x

psmatch2 cc01leav i.redu  i.spedu i.bch1 i.jobssm  i.type  i.szl i.pld tenure if lmonth==1 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & timeen ~= . & timest ~= ., logit caliper(0.1) noreplacement descending
pstest
sort _id 
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
/*1/4SDはPSによるが上のspecificationだと0.073641*/

gen group=.
replace group = 1 if treated ~=.
replace group = 0 if cont ~=.
