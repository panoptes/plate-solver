FROM debian:buster-slim

#COPY solve-listener.sh /solve-listener.sh

RUN apt-get update && \
    apt-get install --no-install-recommends -y astrometry.net wget inotify-tools && \
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

#ENTRYPOINT ["./solve-listener.sh"]
ENTRYPOINT ["solve-field"]
