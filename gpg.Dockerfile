FROM alpine:3.14

RUN apk update
RUN apk add gpg

ENTRYPOINT [ "gpg" ]
