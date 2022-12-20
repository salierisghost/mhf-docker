FROM golang:1.19.4-bullseye

RUN apt install supervisor

COPY *.sh /
COPY supervisord.conf supervisord.conf

ENTRYPOINT ["./entrypoint.sh"]