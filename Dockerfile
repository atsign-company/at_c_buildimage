FROM debian:bullseye-20260824-slim@sha256:e5b6442dd2e9684cf5e87d8338b5968f3b348636fc0be6d7850a381e3731a2bd AS build
COPY clang-19.apt /tmp
ARG CMAKE_VERSION=3.31.8
# Debian 11 (kept for the glibc 2.31 compatibility floor) reached LTS
# end-of-life on 2026-08-31. bullseye + bullseye-updates moved to
# archive.debian.org; bullseye-security's pool is being purged from
# deb.debian.org (indices remain but package files 404), so security
# packages come from the snapshot.debian.org mirror already present
# (commented out) in the image's sources.list, pinned to the base image
# date. Neither archive nor snapshot refresh their Release files, so apt
# must not enforce Valid-Until. Move security to
# archive.debian.org/debian-security once bullseye appears there.
RUN set -eux; \
  echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99bullseye-archive; \
  sed -i -e 's|http://deb.debian.org/debian bullseye|http://archive.debian.org/debian bullseye|' \
         -e 's|^deb http://deb.debian.org/debian-security|# &|' \
         -e 's|^# deb http://snapshot.debian.org/archive/debian-security|deb http://snapshot.debian.org/archive/debian-security|' \
         /etc/apt/sources.list; \
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
