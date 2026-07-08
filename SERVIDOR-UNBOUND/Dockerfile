FROM alpine:3.20 AS builder

RUN apk add --no-cache \
    build-base \
    expat-dev \
    libmnl-dev \
    libsodium-dev \
    linux-headers \
    openssl-dev \
    protobuf-c-dev \
    python3

ARG UNBOUND_VERSION=1.22.0

RUN wget -q "https://nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz" \
    && tar xzf "unbound-${UNBOUND_VERSION}.tar.gz" \
    && cd "unbound-${UNBOUND_VERSION}" \
    && ./configure \
        --prefix=/opt/unbound \
        --sysconfdir=/opt/unbound/etc \
        --with-libmnl \
        --with-libsodium \
        --with-pyunbound \
        --with-ssl \
        --enable-cachedb \
        --enable-dnscrypt \
        --enable-dnstap \
        --enable-subnet \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf "/unbound-${UNBOUND_VERSION}"*

FROM alpine:3.20

RUN apk add --no-cache \
    ca-certificates \
    expat \
    libmnl \
    libsodium \
    libssl3 \
    protobuf-c \
    tini \
    tzdata

COPY --from=builder /opt/unbound /opt/unbound

RUN mkdir -p \
    /opt/unbound/etc/unbound/conf.d \
    /opt/unbound/etc/unbound/local-data \
    /opt/unbound/etc/unbound/cache \
    /opt/unbound/etc/unbound/run \
    /var/log/unbound

RUN addgroup -S unbound \
    && adduser -S -D -H -h /opt/unbound/etc/unbound -s /sbin/nologin -G unbound unbound

RUN chown -R unbound:unbound /opt/unbound /var/log/unbound

COPY unbound.conf /opt/unbound/etc/unbound/unbound.conf
COPY conf.d/ /opt/unbound/etc/unbound/conf.d/
COPY local-data/ /opt/unbound/etc/unbound/local-data/
COPY scripts/ /opt/unbound/etc/unbound/scripts/

EXPOSE 53/udp 53/tcp 853/tcp

USER unbound

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/unbound/sbin/unbound", "-d"]
