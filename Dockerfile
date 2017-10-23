FROM apstra/aos-pyez:api_token_verification
MAINTAINER community@apstra.com

RUN rm -rf /source && mkdir /source
WORKDIR /source

COPY *.* /source/
COPY lib lib
COPY bin bin
COPY packaging packaging
COPY contrib contrib
COPY docs docs
COPY examples examples
COPY hacking hacking

RUN apk update &&\
    apk upgrade &&\
    apk add build-base gcc g++ make libxslt-dev libxml2-dev libffi-dev openssl-dev sshpass &&\
    update-ca-certificates  &&\
    pip install -r requirements.txt  &&\
    pip install -r requirements-network.txt &&\
    python setup.py install &&\
    apk del -r --purge gcc make g++ &&\
    rm -rf /source/* &&\
    rm -rf /var/cache/apk/*

COPY contrib/inventory/apstra_aos.py /etc/ansible/hosts
RUN chmod +x /etc/ansible/hosts

RUN echo "[default]\nhost_key_checking = False\nretry_files_enabled = False" > /etc/ansible/ansible.cfg

ENV ANSIBLE_HOST_KEY_CHECKING=False

WORKDIR /scripts

# ENTRYPOINT ['ansible-playbook']
