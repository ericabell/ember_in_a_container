FROM node:latest

WORKDIR /usr/src/app/my-ember-app

ENV PATH=/usr/src/app/bin:$PATH

RUN set -ex \
  && npm install -g ember-cli \
  && npm install -g bower \
  && npm install -g check-dependencies

RUN set -ex \
  && export WATCHMAN_VERSION=4.6.0 \
  && curl -SL "https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz" | tar -xz -C /tmp/ \
  && cd /tmp/watchman-${WATCHMAN_VERSION} \
  && ./autogen.sh \
  && ./configure \
  && apt-get update && apt-get install -y --no-install-recommends python-dev \
  && make \
  && make install \
  && apt-get purge -y --auto-remove python-dev \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

EXPOSE 4200 35730

CMD ["ember", "server", "--live-reload-port", "35730"]
