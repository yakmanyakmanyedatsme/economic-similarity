# from instruction specifies the parent image 
FROM nuest/mro

ARG WHEN

RUN R -e "options(repos = `
	list(CRAN='http://mran.revolutionanalytics.com/snapshot/${WHEN}')); `
	install.packages(tidyverse);`
	install.packages(data.table);`
	install.packages(dplyr);`
	install.packages(haven)"

RUN mkdir data
RUN mkdir data/idx
COPY gs://china-financial-data/cash_flow_data.dta /data/cash_flow_data.dta
COPY gs://china-financial-data/cash_flow_reg_data.dta /data/cash_flow_reg_data.dta
COPY gs://china-financial-data/indexes/indx_perm_1_1_group.csv /data/idx/idx_file.csv
COPY rscript.R rscript.R
CMD R -e "source('rscript.R')"
