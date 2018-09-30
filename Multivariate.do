cd "/Users/fumiyau/Documents/GitHub/JGSSLCSPatLeave/Results/Multivariate"
gen lmonth2=lmonth*lmonth/100
gen tenurex=tenure/12
*Regressions
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. , nolog noemptycells
est sto expl1
eststo: quietly logit quit c.lmonth##i.cc01leav c.lmonth2##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenurex  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. & group ~=., nolog noemptycells
est sto expl2
quietly esttab expl1 expl2 using lcs_reg_120.csv, se scalar(N ll aic r2_p) star(† 0.1 * 0.05 ** 0.01 *** 0.001) b(3)  replace label  wide  noomitted title(Exploration: Including Cases after 2011)
*Margins
quietly logit quit c.lmonth##i.cc01leav c.lmonth##c.lmonth##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenure  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. , nolog noemptycells
quietly estpost margins cc01leav, at(lmonth=(1(1)120))  
quietly esttab . using margins_obs120.csv, replace r(b) label wide nostar
quietly logit quit c.lmonth##i.cc01leav c.lmonth##c.lmonth##i.cc01leav i.redu i.spedu i.bch1 i.jobssm i.type i.szl i.pld tenure  if lmonth <= 120 & type ~=3 & redu ~=. & spedu ~=. & bch1 ~=. & jobssm ~=. & type ~=. & szl ~=. & pld ~=. & tencat ~=. & jobssm1 ~=. & sz1 ~=. &  type1 ~=. & cc01leav ~=. & group ~=., nolog noemptycells
quietly estpost margins cc01leav, at(lmonth=(1(1)120))  
quietly esttab . using margins_prop120.csv, replace r(b) label wide nostar
