cd "/Users/fumiyau/Documents/GitHub/JGSSLCS-ChildcareUse/"
log using `"`path'ChildcareUse-Replication`=subinstr("`c(current_date)'"," ","",.)'.log"', replace
*Creating the dateset
do "/Users/fumiyau/Documents/GitHub/JGSSLCS-ChildcareUse/DataConst.do"
*Adding variable/value labels
do "/Users/fumiyau/Documents/GitHub/JGSSLCS-ChildcareUse/Labels.do"
*Submit results
do "/Users/fumiyau/Documents/GitHub/JGSSLCS-ChildcareUse/Descriptive.do"
do "/Users/fumiyau/Documents/GitHub/JGSSLCS-ChildcareUse/PSMatching.do"
do "/Users/fumiyau/Documents/GitHub/JGSSLCS-ChildcareUse/Bivariate.do"
do "/Users/fumiyau/Documents/GitHub/JGSSLCS-ChildcareUse/Multivariate.do"
log close
