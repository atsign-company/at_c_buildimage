FROM debian:bullseye-20260803-slim@sha256:f313b4bd62667092a59b3a664d7d3ab8b5e65f41675f48e81455a15dc5abe792 AS build
COPY clang-19.apt /tmp
ARG CMAKE_VERSION=3.31.8
RUN set -eux; \
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
