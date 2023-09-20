FROM curlimages/curl AS yj
RUN if arch | grep -Eq 'arm|aarch'; \
    then curl -Lo /tmp/yj https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-arm64; \
    else curl -Lo /tmp/yj https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-amd64; \
    fi; \
    chmod +x /tmp/yj

FROM busybox
COPY --from=gerritk/ytt:0.45.0 /usr/bin/ytt /bin/ytt
COPY --from=klakegg/hugo:0.101.0 /bin/hugo /bin/hugo
COPY --from=yj /tmp/yj /bin/yj

ENTRYPOINT [ "hugo" ]
