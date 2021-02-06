FROM abiosoft/caddy:no-stats

ARG HUGO_VERSION=0.80.0
ARG GLIBC_VERSION=2.23-r3

# Install dependencies

RUN apk add --no-cache --upgrade openssh-client git tar curl wget ca-certificates libstdc++

# Install glibc

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-$GLIBC_VERSION.apk" \
  &&  rm "glibc-$GLIBC_VERSION.apk" \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-bin-$GLIBC_VERSION.apk" \
  &&  rm "glibc-bin-$GLIBC_VERSION.apk" \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-i18n-$GLIBC_VERSION.apk" \
  &&  rm "glibc-i18n-$GLIBC_VERSION.apk"

# Install HUGO

RUN curl --silent --show-error --fail --location \
  --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
  "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz" \
  | tar --no-same-owner -C /tmp -xz \
  && mv /tmp/hugo /usr/bin/hugo \
  && chmod 0755 /usr/bin/hugo \
  && git config --global fetch.recurseSubmodules true \
  && apk del curl tar wget ca-certificates \
  && mkdir -p /www/public

WORKDIR /www

COPY Caddyfile /etc/Caddyfile

ENV REPO github.com/spf13/spf13.com
