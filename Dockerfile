FROM debian:buster-slim
ARG username=panoptes
ARG incoming_dir=/incoming
ARG outgoing_dir=/outgoing

ARG DEBIAN_FRONTEND=noninteractive

ENV INCOMING_DIR=$incoming_dir
ENV OUTGOING_DIR=$outgoing_dir
ENV SOLVE_OPTS="--guess-scale --no-verify --downsample 4 --temp-axy --no-plots --dir $outgoing_dir"

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      wget ca-certificates bzip2 \
      dcraw exiftool libcfitsio-bin \
      inotify-tools rawtran \
      && \
    # Add user.
    useradd -ms /bin/bash ${username} && \
    # Copy astrometry files.
    for i in {4110..4119}; do \
      wget http://data.astrometry.net/4100/index-${i}.fits -O /usr/share/astrometry/index-${i}.fits; \
    done && \
    # Set up directories.
    mkdir "${incoming_dir}" && \
    mkdir "${outgoing_dir}" && \
    chown -R ${username}:${username} "${incoming_dir}" && \
    chown -R ${username}:${username} "${outgoing_dir}" && \
    chown -R ${username}:${username} /usr/share/astrometry && \
    chown -R ${username}:${username} /opt/conda && \
    # Cleanup
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

USER ${username}
WORKDIR /app
COPY watcher.sh .
CMD ["/bin/bash", "watcher.sh"]
