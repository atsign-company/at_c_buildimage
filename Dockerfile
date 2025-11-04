FROM debian:bullseye-20251103-slim@sha256:75e0b7a6158b4cc911d4be07d9f6b8a65254eb8c58df14023c3da5c462335593 AS build
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
