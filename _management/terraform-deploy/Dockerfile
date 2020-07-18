FROM python:3.8-slim-buster

ENV TERRAFORM_VERSION=0.12.28

RUN apt-get update \
    && apt-get install -y ca-certificates bash git wget unzip gcc \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/tmp/*

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

ADD deploy.py /home/deploy.py

CMD ["/home/deploy.py"]
ENTRYPOINT ["python"]