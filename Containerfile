FROM debian:stable

ARG U_ID=1000
ARG G_ID=1000

ENV DEBIAN_FRONTEND="noninteractive"
ENV NODE_VERSION=v24.18.0
ENV NODE_FILE=node-${NODE_VERSION}-linux-x64.tar.xz

COPY noinstall-recommends /etc/apt/apt.conf.d/

RUN groupadd --gid ${G_ID} antora
RUN useradd \
    --uid ${U_ID} \
    --gid ${G_ID} \
    --shell /usr/bin/bash \
    --home-dir /antora \
    --create-home \
    antora

RUN apt-get update && apt-get install \
    bundler \
    git \
    ruby \
    ruby-dev \
    wget \
    xz-utils --yes  && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://nodejs.org/dist/${NODE_VERSION}/${NODE_FILE} -P /tmp && \
    tar xf /tmp/${NODE_FILE} -C /usr/local --strip-components=1 && \
    rm /tmp/${NODE_FILE} && \
    npm install -g npm@11.18.0

USER antora
COPY Gemfile /antora/
COPY package.json /antora/
WORKDIR /antora

RUN bundle config set deployment false && \
    bundle config set path .bundle/gems/ && \
    bundle install && \
    npm install

CMD ["antora"]
