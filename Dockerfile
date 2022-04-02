# from instruction specifies the parent image 
FROM nuest/mro

RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('data.table')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('haven')"

RUN mkdir data
RUN mkdir data/idx
RUN gsutil rsync gs://china-financial-data/cash_flow_data.dta /data/
RUN gsutil rsync gs://china-financial-data/cash_flow_reg_data.dta /data/
RUN gsutil rsync gs://china-financial-data/indexes/indx_perm_1_1_group.csv /data/
COPY rscript.R rscript.R
CMD R -e "source('rscript.R')"
RUN gsutil rsync /data/R2_cash_flow.csv gs://china-financial-data/kaniko/