cd "/Users/fumiyau/Documents/GitHub/JGSSLCSPatLeave/Results/Bivariate"
stset lmonth if lmonth < 121, id(id) failure(quit==1)
qui sts graph if lmonth < 121, by(cc01leav) ciopts(cc01leav) level(95) title("A.調整前（N=293）") xtitle("勤続月数")  legend(order(2 1) label(1 "非取得") label(2 "取得")) saving(lcsobs.gph,replace)
qui sts graph if lmonth < 121, by(group) title("B.調整後（N=156）") xtitle("勤続月数")  legend(order(2 1) label(1 "非取得") label(2 "取得")) saving(lcsprop.gph,replace)
qui graph use lcsobs.gph
qui graph use lcsprop.gph
graph combine lcsobs.gph lcsprop.gph,saving(Figure2.gph, replace)
sts list if group ~=., by(cc01leav) compare at (0 1 to 120)
sts list , by(cc01leav) compare at (0 1 to 120)
