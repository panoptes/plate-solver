FROM debian:buster-slim
ARG username=panoptes
ARG incoming_dir=/incoming
ARG outgoing_dir=/outgoing

ARG DEBIAN_FRONTEND=noninteractive

ENV INCOMING_DIR=$incoming_dir
ENV OUTGOING_DIR=$outgoing_dir
ENV SOLVE_OPTS="--guess-scale --no-verify --downsample 4 --temp-axy --no-plots --dir $outgoing_dir"

ADD http://data.astrometry.net/4100/index-4110.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4111.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4112.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4113.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4114.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4115.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4116.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4117.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4118.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4119.fits /usr/share/astrometry/

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      wget ca-certificates bzip2 \
      astrometry.net dcraw exiftool libcfitsio-bin \
      inotify-tools rawtran \
      && \
    # Add user.
    useradd -ms /bin/bash ${username} && \
    # Set up directories.
    mkdir "${incoming_dir}" && \
    mkdir "${outgoing_dir}" && \
    chown -R ${username}:${username} "${incoming_dir}" && \
    chown -R ${username}:${username} "${outgoing_dir}" && \
    chown -R ${username}:${username} /usr/share/astrometry && \
    # Cleanup
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

USER ${username}
WORKDIR /app
COPY watcher.sh .
CMD ["/bin/bash", "watcher.sh"]
