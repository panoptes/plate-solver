FROM python:3.10-slim-buster
ARG username=solve-user

ARG DEBIAN_FRONTEND=noninteractive

ADD http://data.astrometry.net/4100/index-4110.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4111.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4112.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4100/index-4108.fits /usr/share/astrometry/
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
      astrometry.net dcraw exiftool \
      && \
    useradd -ms /bin/bash ${username} && \
    chown -R ${username}:${username} /usr/share/astrometry && \
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

USER "${username}"
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY watcher.py .
COPY handler.py .
ENTRYPOINT [ "/app/watcher.py" ]
CMD [ "--directory ." ]
