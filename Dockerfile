# from instruction specifies the parent image 
FROM nuest/mro
ARG WHEN
RUN R -e "options(repos = \
	list(CRAN='http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
	install.packages(tidyverse);\
	install.packages(data.table);\
	install.packages(dplyr);\
	install.packages(haven)"

mkdir

Copy cash_flow_data.dta /home/data/cash_flow_data.dta
Copy cash_flow_reg_data.dta /home/data/cash_flow_reg_data.dta

Copy economic_similarity.R /home/code/economic_similarity.R
CMD R -e "source('/home/code/economic_similarity.R')"
