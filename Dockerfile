# DOCKER-VERSION 1.9.1
FROM centos:7
MAINTAINER kballou@devnulllabs.io

ENV LANG="en_US.UTF-8"
ENV OTP_VER="18.3.4"
ENV REBAR_VERSION="2.6.1"
ENV REBAR3_VERSION="3.1.0"
ENV ELIXIR_VERSION="1.2.5"

RUN set -xe \
    && yum -y groupinstall "Development Tools" \
    && yum -y install ncurses \
        ncurses-devel \
        unixODBC \
        unixODBC-devel \
        openssl-devel \
    && OTP_SRC_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VER.tar.gz" \
    && OTP_SRC_SUM="d9e68a8cdef4db0935b02d4b163cf3af403405f756488874736298cf48b90ae9" \
    && curl -fSL "$OTP_SRC_URL" -o otp-src.tar.gz \
    && echo "${OTP_SRC_SUM}  otp-src.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/otp-src \
    && tar -zxf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
    && rm otp-src.tar.gz \
    && cd /usr/src/otp-src \
    && ./otp_build autoconf \
    && ./configure \
    && make \
    && make install \
    && find /usr/local -name examples | xargs rm -rf \
    && cd /usr/src \
    && rm -rf /usr/src/otp-src \
    && REBAR_SRC_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION##*@}.tar.gz" \
    && REBAR_SRC_SUM="aed933d4e60c4f11e0771ccdb4434cccdb9a71cf8b1363d17aaf863988b3ff60" \
    && mkdir -p /usr/src/rebar-src \
    && curl -fSL "$REBAR_SRC_URL" -o rebar-src.tar.gz \
    && echo "${REBAR_SRC_SUM}  rebar-src.tar.gz" | sha256sum -c - \
    && tar -zxf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
    && rm rebar-src.tar.gz \
    && cd /usr/src/rebar-src \
    && ./bootstrap \
    && install -v ./rebar /usr/local/bin \
    && cd /usr/src \
    && rm -rf /usr/src/rebar-src \
    && REBAR3_SRC_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION##*@}.tar.gz" \
    && REBAR3_SRC_SUM="b426cf7829d5df0d6d3e50cd501a1688bdbc878b0ca69d63240a0614afbd9c64" \
    && mkdir -p /usr/src/rebar3-src \
    && curl -fSL "$REBAR3_SRC_URL" -o rebar3-src.tar.gz \
    && echo "${REBAR3_SRC_SUM}  rebar3-src.tar.gz" | sha256sum -c - \
    && tar -zxf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
    && rm rebar3-src.tar.gz \
    && cd /usr/src/rebar3-src \
    && HOME=$PWD ./bootstrap \
    && install -v ./rebar3 /usr/local/bin \
    && cd /usr/src \
    && rm -rf /usr/src/rebar3-src \
    && ELIXIR_SRC_URL="https://github.com/elixir-lang/elixir/archive/v$ELIXIR_VERSION.tar.gz" \
    && ELIXIR_SRC_SUM="8ed65722aeb55cbfe6022d77d0e36293d463d7b4922198f5c157e8286d896eee" \
    && curl -fSL "$ELIXIR_SRC_URL" -o elixir.tar.gz \
    && echo "${ELIXIR_SRC_SUM}  elixir.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/elixir-src \
    && tar -zxf elixir.tar.gz -C /usr/src/elixir-src --strip-components=1 \
    && rm -f elixir.tar.gz \
    && cd /usr/src/elixir-src \
    && make install \
    && cd / \
    && rm -rf /usr/src/elixir-src \
    && mix local.hex --force \
    && mix hex.info
