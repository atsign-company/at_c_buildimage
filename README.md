<a href="https://atsign.com#gh-light-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2022/05/atsign-logo-horizontal-color2022.svg#gh-light-mode-only" alt="The Atsign Foundation"></a><a href="https://atsign.com#gh-dark-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2023/08/atsign-logo-horizontal-reverse2022-Color.svg#gh-dark-mode-only" alt="The Atsign Company"></a>

[![SLSA 3](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev)

# at_c_buildimage

Installing all the packages needed to build (multiplatform) binaries for a C
application is time consuming, so that work happens here, and the image
can then be used to accelerate builds elsewhere.

## SLSA

The Docker images created from this repo have SLSA Build Level 3 attestations.

These can be verified using the
[slsa-verifier](https://github.com/slsa-framework/slsa-verifier) tool e.g.:

```sh
CMAKE_VERSION="3.30.2"
IMAGE="atsigncompany/cbuildimage"
SHA=$(docker buildx imagetools inspect ${IMAGE}:CMake-${CMAKE_VERSION} \
  --format "{{json .Manifest}}" | jq -r .digest)
slsa-verifier verify-image ${IMAGE}@${SHA} --source-uri \
  github.com/atsign-company/at_c_buildimage --source-tag c${CMAKE_VERSION}
```
