FROM python:3-slim
ARG username=panoptes

ARG DEBIAN_FRONTEND=noninteractive

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
      dcraw exiftool libcfitsio-bin \
      astrometry.net \
      && \
    # Add user.
    useradd -ms /bin/bash ${username} && \
    # Cleanup
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

ARG incoming_dir=/incoming
ARG outgoing_dir=/outgoing
ENV INCOMING_DIR=$incoming_dir
ENV OUTGOING_DIR=$outgoing_dir

COPY requirements.txt .
RUN pip install -r requirements.txt && \
    # Set up directories.
    mkdir "${incoming_dir}" && \
    mkdir "${outgoing_dir}" && \
    chown -R ${username}:${username} "${incoming_dir}" && \
    chown -R ${username}:${username} "${outgoing_dir}"

USER ${username}
WORKDIR /app
COPY watcher.py .
CMD ["python", "watcher.py"]
