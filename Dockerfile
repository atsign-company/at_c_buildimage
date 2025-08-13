FROM debian:oldstable-20250811-slim@sha256:5dbf1b5b02f8e014bd468b013a35d650d8f05e2604818db8d03efefc90220761 AS build
# 20250811 patch sources.list to use oldoldstable whilst we await Debian
# image updates in DockerHub
COPY oldoldstable.apt /tmp
COPY clang-19.apt /tmp
ARG CMAKE_VERSION=3.31.8
RUN set -eux; \
  cat /tmp/oldoldstable.apt > /etc/apt/sources.list; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates gnupg git make patch python3 wget; \
  cat /tmp/clang-19.apt >> /etc/apt/sources.list; \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -; \
  apt-get update; \
  apt-get install -y --no-install-recommends clang-19; \
  cd /; \
  case "$(dpkg --print-architecture)" in \
    amd64)   ARCH="x86_64";;\
    arm64)   ARCH="aarch64";; \
  esac; \
  wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${ARCH}.tar.gz; \
  tar -xvf cmake-${CMAKE_VERSION}-linux-${ARCH}.tar.gz --strip-components=1 -C /usr/; \
  cmake --version
