FROM debian:buster-slim

COPY bin/solve-field /tmp

RUN apt-get update && \
    apt-get install --no-install-recommends -y astrometry.net && \
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

ENTRYPOINT ["solve-field"]
