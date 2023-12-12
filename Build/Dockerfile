FROM golang:1.19.4-bullseye

RUN apt update && \
    apt install -y supervisor && \
    mkdir /Erupe && \
    mkdir -p /var/log/supervisord && \
    mkdir -p /var/run/supervisord 

COPY *.sh /
COPY supervisord.conf /supervisord.conf

WORKDIR /Erupe

ENTRYPOINT ["/entrypoint.sh"]