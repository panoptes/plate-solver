FROM debian:buster-slim

ADD http://data.astrometry.net/4200/index-4209.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4210.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4211.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4212.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4208.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4213.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4214.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4215.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4216.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4217.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4218.fits /usr/share/astrometry/
ADD http://data.astrometry.net/4200/index-4219.fits /usr/share/astrometry/

COPY ./bin/ /app/
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget astrometry.net && \
    useradd -ms /bin/bash solve-user && \
    chown -R solve-user:solve-user /usr/share/astrometry && \
    apt-get autoremove --purge -y && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

USER solve-user
WORKDIR /tmp
CMD ["/usr/bin/solve-field"]
