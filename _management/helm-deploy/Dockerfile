FROM python:3.8-slim-buster

MAINTAINER Andrew Dunn

ENV KUBE_LATEST_VERSION="v1.18.3"
ENV HELM_VERSION="v3.2.4"

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates bash git wget curl gcc \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

ADD deploy.py /home/deploy.py

CMD ["/home/deploy.py"]
ENTRYPOINT ["python"]