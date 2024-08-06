FROM debian:oldoldstable-20240612-slim@sha256:297126bdb5f6b3dd2ce43c87fcd67678f3b8b2ecbed94fb9f18bbccca522bcb1 AS build
COPY clang-18.apt /tmp
ENV CMAKE_VERSION=3.30.2
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates gnupg git make wget; \
  cat /tmp/clang-18.apt >> /etc/apt/sources.list; \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -; \
  apt-get update; \
  apt-get install -y --no-install-recommends clang-18; \
  cd /; \
  case "$(dpkg --print-architecture)" in \
    amd64)   ARCH="x86_64";\
    arm64)   ARCH="aarch64"; \
  esac; \
  wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-$ARCH.tar.gz; \
  tar -xvf cmake-${CMAKE_VERSION}-linux-$ARCH.tar.gz --strip-components=1 -C /usr/; \
  cmake --version