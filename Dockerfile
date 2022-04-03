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

RUN echo '{"type": "service_account", "project_id": "quantum-ether-337220", "private_key_id": "de8051e4aa9572db455b6936479e7ca26991ddbe", "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCtlySCYxpnIvCY\\nu21ROIreDtdh+YP1nTCJDT0mwkMqBYbdl2R3f0Anm/bEx6+plY4aVeXzurF4BCHX\\njf/R12XFYi1NCdSnUVzdWKjKic5PNn4YmabRP4eaFsvNYlLMSrScBn6xWuoS9puN\\nnSmyuXVQEvc7o0GrnkKln/E31FzDNxRZr7buTfX7UuXgKWt7Wqnx9LYjfJ6ZYMUt\\nVKNKxrqSFuQ2OYJbYhi/OT/6RK4wi9b/INlz5PulVFeK6YwHmakLUPNtUXTGRIvo\\nkyY29RylrFlzrF5Uh6NqaqFWy9ZtuuzyHYbcLa/Mgos1AKhGG9maJPdkNVR4cpBg\\nbGo37XdbAgMBAAECggEARuZuJ4ExxgE70q3uytc0xNi7+MzQLG/c5IVPPjbm9tFW\\nEcilZLdJLURi6GGE6ldmuHPwHXnZxWKurdtWKs92xkVAqnAC9qnhK5jsK/lYFft0\\nSjjrrRhtGq8H46WumrlChl2Svn6bD07BHvibkN91vlRYvXeDOYTExOAMRljK4IJA\\n7Yh9hiNYqAviBul0l+I2pgUDXhkNsq9kQJ+dOVIGg7tlZmkprWYDHWx5e8+oZKa2\\n4+/w8xvYR6mdhHBFU8axg1RaGy4eRCo8qWS9SdUzVLnXEhB22m32dJg6vSsm8xAc\\nzOdORDJMaGW6EHwNr1O4gvrEtXZtFrV7gUHm4zj3UQKBgQDT5bV9N1cNEQxJybA3\\n1Me/fBgoqPQ/zIR0yBnB5RuXXdlIVZmG73TFfqErPax1qa/gkTnGiKUAZdjF8Hvl\\nfRgXblWUbtt4CAN+cf2iJcfVQ+YYxJ9mmPZWCocrPFwviwoqLz/U7kq6n+NWFLjL\\n3vF1In3gWi0St5NXER8+BVaa8QKBgQDRuF6FVuqG0KsTvi9fqQO3WpMJWTBrHvcc\\nzZxp9u5lkxrvFuYrlto+xtmwl03JzaUaovRwwQmAigKIKwHCJE6IjR8gR2DSsWyX\\n9ygL5ZSJu1QcN8F8ZMhFgMMvWxMKEyUihhPFqgkI/lTm0y98Y1OdN5/6PEi9kzpW\\nJHdGq0u/CwKBgQDAXyk3dshXGoUXcD3FUi3OD/E26LxmN1yBUTDhMQitkQw0eVIa\\niMZwjhfv09wALn931yCmt2NlSxFUEpHItJrsmsSjL0mcXVoer4pebQJRAYWiMs+s\\nK25oisJQZEok94vQ5HiE7Zl2eLXBbqqem9aGSzwQNI37EiJ3xxmgCuSnYQKBgQC0\\nGCabTLtTkGgJKT4XYNW/I7m2wm+Q3eOJSYwzdwjcE0qC3OBFuGKsnCievB/h14Yb\\n7KoLFcoqJtnrwzrcVD9Yhg+fsYwVAqXljipGpR08dbDSFpNCVm2hOeTjiss70JsI\\nHalnChB+N6IDIoHZyJYqIXVw90nj+kWTafc/qaP/ZwKBgQC2bsvgQBoHcDIoZcQA\\nBiTwjmqdE6AzQTGBkLjPuu7nhmll55ZJgLz16RPQLjTESPLI1iBwobWE2Zeu1036\\nCdo1b7Wocg0bkOUsl2vzi57Iu+IFy8aUGfgdrPR5aWKXK/ulFprjKWvdeQiMh+3W\\n0lN8DU0a7bEbSxv4CB9tYcxVCA==\\n-----END PRIVATE KEY-----\\n", "client_email": "quantum-ether-337220@appspot.gserviceaccount.com", "client_id": "108391566088998469424", "auth_uri": "https://accounts.google.com/o/oauth2/auth", "token_uri": "https://oauth2.googleapis.com/token", "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/quantum-ether-337220%40appspot.gserviceaccount.com"}' > credential_key.json

RUN gcloud auth activate-service-account --key-file=credential_key.json
RUN gcloud config set project quantum-ether-337220


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