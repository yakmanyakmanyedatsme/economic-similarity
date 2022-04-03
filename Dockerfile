# from instruction specifies the parent image 
FROM nuest/mro

RUN apt-get update -y

RUN apt-get install -y python

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN echo '{\
  "type": "service_account",\
  "project_id": "quantum-ether-337220",\
  "private_key_id": "29d2f175f4ca8be6c574864be1d455ec0d1e558b",\
  "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7aXCcsX+hJgJD\\njWvc+n9No3dhyUjEVRYBi/qMjWzXe1IW0qsQThmWpSx3/jHSIz7pnQOfRNb0s80/\\nVBc+iijMwN+jQp/Y/af1c06UW0C16SSn+l/AgKAJZN/em+O6DibGi/atbQK4/b3Y\\n9NjIE7praxDYuJRVCsHW+RVOzsdbK62NpRHpniwIjHnFNTerxP1ibZyVWuf+yiZf\\n8UL28cFONB9tZ6Q6BoIMK0lZU6MuoVjgNr4mGMWqmA8VYovt3Af4JRP3GcWasW9N\\ncQi/zB8hQShEvgi1EBZ5WI1+xOivz62kNX4s7FaICQbRqN/rRc3YtPYeZZs79S5K\\n0dywc8mFAgMBAAECggEAH8Dds67fUQ5/k7KCdA59Q0pPD+Jq0dkYwWpWKTpNFrVu\\nUy+ejESvUTbrMel/x3rxTeOsmW+wfAV64R/+UDpYb1i+i4reSoWvz4aZ6ckMTcYS\\nz+M8FgG1G+Jbi/wduYhsSXetc/TkYTOc1wWlNUEidNDPKekcOMx5y1KoqZGfdXLG\\nc526XCsq6nDH79rAWqo5XW5ff9OIhCwp4Xm9wwk87t+BOQ7Y3qaZ6X+r/bQLkwp6\\nJ3t6euhFVD0+ahViC1KmxMc4K4sRmk2xWT9W75v14wbZXQie5YAkAT+W99k8ChfW\\nAcl3VV/qYg86jDnE5Di3BrWDpCQu2f9OY7gBhR6oAQKBgQDzLo37996biu9oBw57\\nasHwKVT/+khFdVsjCAV2Tn9cVPgmdUOIqCEgksIbj6ptkFKDL8saO4BnmS+CcYVM\\nPSt0k0nW6ZPjcTsEefKdXZy9E3rG4R46KxlJy5xBS1LFixFoJ9GaAUsicYrTJdic\\ngepRGPzpNJ7CsiJxJ6HE15VMMQKBgQDFSlY1zvJOVSLqoJRJaJtN9/7cdnvw7gdn\\nXQB5XcXC2ZfSCjbgPREUYHmm1vCOuRisst9sEaHz6YKtq4XqGDxU4fOnmCVNv/rx\\nrL738xYsOKPKD3mJmjeAqH0HyZLgq0suBlysIMPiJt7s86UUPeKbApC2ATRVQqwu\\nrnm/YhZBlQKBgQDAQ9OAHnZC1fL4dXPOwhY5cgRBKjmPqPx4UvQ2mFN7xbY4ecf+\\nOKeQYFfVgJ3HaC7Eh7n1sIuR3PxCDszL/STpUzYzE5OYZEK8BEp8frHYj5knun6y\\nkLa6sJ+GxC3Z/1yw06KVN2aXAdw3mpmLC/AdVDtJig/ncP1oJ2RwA96HUQKBgQC8\\nStpEuKIhiLeuXluoRCIVI98l4h8gLsz6JZTSQGECOlHfsMf289FdNUZlqTYlwRp/\\nmKgLqDh9ZhvGTLGeXksWaB/3kAnqTpPeHBSW6HX89oG701EXtwvJywSpbgS0UEeM\\nQZ4o2YyaRqb0VwTycK3Za3VZf4TG6r8SPosL0T2UkQKBgQDc8Uw/KuJYy5rwjmKp\\n9+8Qyhd2y57Waja1ST6UA2XJZVdFuFFrT5cQeeiU6sjN9Krx94WF45n5FFK9oFuN\\n/YHHXPGIvyGnQZmr/OB9qUf6oNGrLEwkQCrFXm2V0529D+R8Jg9yXekuzTIj98wg\\nh6vWgFtAN18jCZd5yliaKtwyHQ==\\n-----END PRIVATE KEY-----\\n",\
  "client_email": "685930908395-compute@developer.gserviceaccount.com",\
  "client_id": "115711818843704465192",\
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",\
  "token_uri": "https://oauth2.googleapis.com/token",\
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",\
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/685930908395-compute%40developer.gserviceaccount.com"\
}' > credential_key.json


RUN gcloud auth activate-service-account --key-file=credential_key.json

RUN mkdir /data
RUN mkdir /data/idx
RUN gsutil cp gs://china-financial-data/cash_flow_data.dta /data/
RUN gsutil cp gs://china-financial-data/cash_flow_reg_data.dta /data/
RUN gsutil cp gs://china-financial-data/indexes/indx_perm_1_1_group.csv /data/
COPY rscript.R rscript.R

RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('data.table')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('haven')"

CMD R -e "source('rscript.R')"
RUN gsutil cp /data/R2_cash_flow.csv gs://china-financial-data/kaniko/