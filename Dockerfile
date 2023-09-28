FROM alpine:3.18.3

RUN \
    apk --no-cache add nftables && \
    apk --no-cache add libcap && \
    setcap cap_net_admin+ep /usr/sbin/nft && \
    apk --no-cache del libcap

COPY assets/ /

USER 65534

ENTRYPOINT ["/usr/local/sbin/setup-nft-redirect"]
