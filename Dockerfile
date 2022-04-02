# from instruction specifies the parent image 
FROM nuest/mro

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN mkdir /data
RUN mkdir /data/idx
RUN gsutil rsync gs://china-financial-data/cash_flow_data.dta /data/
RUN gsutil rsync gs://china-financial-data/cash_flow_reg_data.dta /data/
RUN gsutil rsync gs://china-financial-data/indexes/indx_perm_1_1_group.csv /data/
COPY rscript.R rscript.R

RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('data.table')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('haven')"

CMD R -e "source('rscript.R')"
RUN gsutil rsync /data/R2_cash_flow.csv gs://china-financial-data/kaniko/