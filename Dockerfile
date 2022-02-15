FROM condaforge/miniforge3
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

COPY --chown=${username}:${username} environment.yaml /tmp/env.yaml
RUN /opt/conda/bin/conda install -c conda-forge -y mamba && \
    /opt/conda/bin/mamba env update --file /tmp/env.yaml && \
    /opt/conda/bin/mamba clean --all --yes

USER "${username}"
WORKDIR /app
COPY watcher.py .
COPY handler.py .
ENTRYPOINT [ "/opt/conda/bin/python /app/watcher.py" ]
CMD [ "--directory ." ]
