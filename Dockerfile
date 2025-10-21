FROM debian:bullseye-20251020-slim@sha256:52927eff8153b563244f98cdc802ba97918afcdf67f9e4867cbf1f7afb3d147b AS build
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
