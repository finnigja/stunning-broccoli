FROM alpine:3.19

# keep it simple and use the binary that was built (and attested) in CI, rather than
# doing a separate multi-stage build in here...

ADD stunning-broccoli-linux-amd64 stunning-broccoli

ENTRYPOINT ["/stunning-broccoli"]
