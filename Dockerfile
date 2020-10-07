FROM debian:buster-slim

COPY ./bin/ /app/
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget astrometry.net && \
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
CMD ["/app/solve-field"]
