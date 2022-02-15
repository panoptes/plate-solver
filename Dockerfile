FROM debian:buster-slim
ARG username=solve-user

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
      wget ca-certificates \
      astrometry.net dcraw exiftool \
      && \
    useradd -ms /bin/bash ${username} && \
    chown -R ${username}:${username} /usr/share/astrometry && \
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --chown=${username}:${username} environment.yaml /tmp/env.yaml
RUN wget -q https://micromamba.snakepit.net/api/micromamba/linux-64/latest -O micromamba.tar.bz2 && \
    tar -xvjf micromamba.tar.bz2 bin/micromamba && \
    rm micromamba.tar.bz2 && \
    bin/micromamba install -y -f /tmp/env.yaml && \
    bin/micromamba clean --all --yes && \
    rm micromamba.tar.bz2

COPY watcher.py .
COPY handler.py .
USER solve-user
ENTRYPOINT [ "/app/watcher.py" ]
CMD [ "--handler handler --directory ." ]
