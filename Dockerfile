# syntax=docker/dockerfile:1
FROM debian:10-slim AS base

FROM base AS artifact
COPY ./build/artifacts/ /build/artifacts/
RUN export ARCH=$(bash -c '[ $(uname -m) == "x86_64" ] && echo "amd64" || echo "aarch64"');\
	mv /build/artifacts/linux-${ARCH} /app

FROM base
COPY --from=artifact --chmod=755 /app/dns-proxy-server /app/dns-proxy-server
WORKDIR /app
LABEL dps.container=true
ENV DPS_CONTAINER=1
VOLUME ["/var/run/docker.sock", "/var/run/docker.sock"]
ENTRYPOINT ["/app/dns-proxy-server"]
