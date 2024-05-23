# stunning-broccoli

This repository contains:

* [main.go](main.go), which is the code for an example program. It's just one source file in this example, but could be more.

* [Makefile](Makefile), which is used to locally or in a GHA workflow to build development and release artifacts.

* [Dockerfile](Dockerfile), which defines a simple Alpine-based image containing a binary.

* [build-attested-release.yml](.github/workflows/build-attested-release.yml), which is a GitHub workflow that checks out the code, builds cross-platform binaries, creates an archive containing the binaries, creates an attestation for that archive, and then publishes a release. Once a release is done, it should be considered immutable.

* [build-attested-image.yml](.github/workflows/build-attested-image.yml), which is a GitHub workflow that downloads the most recent release, verifies the attestation, builds and publishes an image containing that release with appropriate tags, and then creates an attestation for that image. Image building is decoupled from release builds, so we can publish new images (with base image security fixes, etc) without having to cut a new release. Images are labeled to provide flexibile options for pinning to specific images or releases, or to float with `latest` builds.

## Building a release and image

The `build-attested-release` workflow is configured to build when a new tag is pushed, with something like:
```
$ git tag v0.0.2 main -m "release v0.0.2"
$ git push origin tag v0.0.2
```

The `build-attested-image` workflow is configured to run when the `build-attested-release` workflow completes, on schedule once a week, and on demand via dispatch.

## Verifying the release archive attestation

A stunning-broccoli release archive can be downloaded and the attestation verified using the `gh` client.

For example:
```
$ curl -sLO https://github.com/finnigja/stunning-broccoli/releases/download/v0.0.2/stunning-broccoli-v0.0.2.tar.gz
$ gh attestation verify ./stunning-broccoli-v0.0.2.tar.gz -o finnigja
Loaded digest sha256:6ee8ca7e9dc320f45ce16e5a0c6717ba3454bc6a3002286f7c482e9d6bd0695d for file://stunning-broccoli-v0.0.2.tar.gz
Loaded 1 attestation from GitHub API
✓ Verification succeeded!

sha256:6ee8ca7e9dc320f45ce16e5a0c6717ba3454bc6a3002286f7c482e9d6bd0695d was attested by:
REPO                        PREDICATE_TYPE                  WORKFLOW
finnigja/stunning-broccoli  https://slsa.dev/provenance/v1  .github/workflows/build-attested-release.yml@refs/tags/v0.0.2
```

A JSON-formatted attestation with more detail can be obtained by adding `--format json` to the `gh attestation verify` command.

## Verifying the container image attestation

A stunning-broccoli container image can also be verified using the `gh` client.

For example:
```
$ docker login ghcr.io  # if you're not already logged in...
$ gh attestation verify oci://ghcr.io/finnigja/stunning-broccoli:v0.0.2-latest -o finnigja
Loaded digest sha256:9bf5c4e833d575130cf13075cfe2ba0f3fea6b002816aaf997de97dcfcbddf87 for oci://ghcr.io/finnigja/stunning-broccoli:v0.0.2-latest
Loaded 1 attestation from GitHub API
✓ Verification succeeded!

sha256:9bf5c4e833d575130cf13075cfe2ba0f3fea6b002816aaf997de97dcfcbddf87 was attested by:
REPO                        PREDICATE_TYPE                  WORKFLOW
finnigja/stunning-broccoli  https://slsa.dev/provenance/v1  .github/workflows/build-attested-image.yml@refs/heads/main
```

## About the attestation feature

For more information about the GitHub artifact attestation feature:
* https://github.blog/2024-05-02-introducing-artifact-attestations-now-in-public-beta/
* https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds

## Why stunning-broccoli?

Courtesy of GitHub's random repository name generation. The fantastic piece of ASCII art packaged here came from [https://emojicombos.com/broccoli-ascii-art](https://emojicombos.com/broccoli-ascii-art).
