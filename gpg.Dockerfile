FROM alpine:3.18.3

RUN apk update
RUN apk add gpg

ENTRYPOINT [ "gpg" ]
