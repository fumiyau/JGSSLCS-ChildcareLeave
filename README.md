# JGSSLCS-ChildcareLeave
Replication files for my publication on parental leave (Childcare Leave Use among Japanese Women and Its Long-termEffect on Occupational Careers)

There are 6 do files (+master fofile) to run the replication. 
0.Master.do - a do file that runs other do files
1.DataConst - a do file that creates dataset for analysis
2.Labels.do - a do file that creates variable/value labels 
3.Descriptive - a do file that submits descriptive statistics (with a logistic regression to predict propensity score)
4.PSMatching.do - a do file that runs propensity score matching
5.Bivariate.do - a do file that examines the bivariate relationship
6.Multivariate.do - a do file that examines the multivariate analysis with marginal effects

Output files are included in the Results folder.
Link to raw data is here: http://jgss.daishodai.ac.jp/english/index.html
Link to the article is here: http://jgss.daishodai.ac.jp/research/monographs/jgssm17/jgssm17_03.pdf
This study used JGSS-2009LCS (Japanese General Social Survey-2009 Life Course Survey, a vearsion in January 2016), and now version 3.0 is available.
I used sav file as raw data and converted it to dta format.

I thank Ryota Mugiyama, Ryohei Mogi, Yuki Hayashikawa, and Toshifumi Yoshida for their advices on this paper and sharing codes for creating the variables.
