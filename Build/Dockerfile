FROM golang:1.19.4-bullseye

COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /supervisord.conf

RUN apt update && \
    apt install -y supervisor p7zip-full && \
    mkdir /Erupe && \
    mkdir -p /var/log/supervisord && \
    mkdir -p /var/run/supervisord && \
    chmod +x /entrypoint.sh

WORKDIR /Erupe

ENTRYPOINT ["/entrypoint.sh"]
