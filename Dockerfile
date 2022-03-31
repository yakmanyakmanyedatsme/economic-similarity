# from instruction specifies the parent image 
FROM nuest/mro
ARG WHEN
RUN R -e "options(repos = \
	list(CRAN='http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
	install.packages(tidyverse);\
	install.packages(data.table);\
	install.packages(dplyr);\
	install.packages(haven)"

mkdir data
mkdir data/idx
Copy gs://china-financial-data/cash_flow_data.dta /data/cash_flow_data.dta
Copy gs://china-financial-data/cash_flow_reg_data.dta /data/cash_flow_reg_data.dta
Copy gs://china-financial-data/indexes/indx_perm_1_1_group.csv /data/idx/idx_file.csv
Copy rscript.R rscript.R
CMD R -e "source('rscript.R')"
