FROM curlimages/curl AS yj
RUN if arch | grep -Eq 'arm|aarch'; \
    then curl -Lo /tmp/yj https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-arm64; \
    else curl -Lo /tmp/yj https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-amd64; \
    fi; \
    chmod +x /tmp/yj

FROM klakegg/hugo:0.111.3-ext-ubuntu
COPY --from=gerritk/ytt:0.45.0 /usr/bin/ytt /bin/ytt
COPY --from=yj /tmp/yj /bin/yj

ENTRYPOINT [ "hugo" ]
