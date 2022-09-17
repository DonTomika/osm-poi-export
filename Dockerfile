FROM debian:buster-slim

# install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      tar \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# download imposm3
RUN mkdir /opt/imposm3 \
  && cd /opt/imposm3 \
  && curl -L 'https://github.com/omniscale/imposm3/releases/download/v0.11.1/imposm-0.11.1-linux-x86-64.tar.gz' --output imposm.tgz \
  && tar xf imposm.tgz --strip-components=1 \
  && ln -s /opt/imposm3/imposm /bin/imposm \
  && rm imposm.tgz

# set up entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["run"]

# bundle source files
WORKDIR /app
ADD poi-export /app
