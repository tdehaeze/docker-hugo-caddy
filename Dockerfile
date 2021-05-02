FROM abiosoft/caddy:1.0.3-no-stats
MAINTAINER dehaeze.thomas@gmail.com

ENV HUGO_VERSION 0.83.0
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz
ENV GLIBC_VERSION 2.27-r0

RUN set -x && \
  apk add --update openssh-client git tar wget ca-certificates libc6-compat libstdc++

# Install HUGO

RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} \
  && tar xzf ${HUGO_BINARY} \
  && rm -r ${HUGO_BINARY} \
  && mv hugo /usr/bin \
  && git config --global fetch.recurseSubmodules true \
  && apk del wget ca-certificates \
  && mkdir -p /www/public

WORKDIR /www

COPY Caddyfile /etc/Caddyfile

ENV REPO github.com/spf13/spf13.com
