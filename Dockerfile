FROM ruby:2.6.0
LABEL maintainer="hola@decidim.org"

ENV USER_ID 1000
ENV GROUP_ID 2000

# Installs system dependencies
# One package each line and sorted alphabetically
# We clean up after as there's some apt caching that we don't need here
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      apt-transport-https \
      build-essential \
      graphviz \
      imagemagick \
      libicu-dev \
      libpq-dev \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

# Installs yarn/nodejs as a dependency
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      nodejs \
      yarn \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

# Sets workdir as /usr/src/app
# We try to follow the Filesystem Hierarchy Standard (FHS)
ENV APP_HOME /usr/src/app/
RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}

# Create an user for the application for security
RUN addgroup --gid ${GROUP_ID} decidim
RUN useradd -m -s /bin/bash -g ${GROUP_ID} -u ${USER_ID} decidim

# Fix permissions problems with bundler
RUN chown -R decidim: /usr/local/bundle

# Changes the active user on the container
USER decidim

# Copy Gemfile and install bundler dependencies
COPY --chown=decidim:decidim Gemfile Gemfile.lock ${APP_HOME}
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=20 \
  BUNDLE_RETRY=5 \
  PATH=${APP_HOME}/bin:${PATH}
RUN gem uninstall bundler
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle install

# We don't expose the port 3000 and we don't start the webserver as this same image
# that we're going to use for the 'worker' service. See the docker-compose.yml file to
# see how the commands are started.
# EXPOSE 3000

# Copy all the code to /usr/src/app
COPY --chown=decidim:decidim . ${APP_HOME}
