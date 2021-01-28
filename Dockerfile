FROM ruby:2.6.0
LABEL maintainer="hola@decidim.org"

ENV USER_ID 1000
ENV GROUP_ID 2000
ENV RAILS_ENV production
ENV LANG=C.UTF-8
ENV BUNDLE_JOBS=20
ENV BUNDLE_RETRY=5
ENV APP_HOME /usr/src/app/
ENV PATH=${APP_HOME}/bin:${PATH}
ENV SECRET_KEY_BASE dummy_key_base

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      apt-transport-https \
      build-essential \
      graphviz \
      imagemagick \
      libicu-dev \
      libpq-dev \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      nodejs \
      yarn \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log \
    && addgroup --gid ${GROUP_ID} decidim \
    && useradd -m -s /bin/bash -g ${GROUP_ID} -u ${USER_ID} decidim \
    && chown -R decidim: /usr/local/bundle

RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}

RUN chown -R decidim: ${APP_HOME}
USER decidim

COPY --chown=decidim:decidim Gemfile Gemfile.lock ${APP_HOME}

RUN gem uninstall bundler \
    && gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)" \
    && bundle install \ 

COPY --chown=decidim:decidim . ${APP_HOME}
RUN bundle exec rails assets:precompile

RUN chmod +x ./sidekiq_alive.sh ./sidekiq_quiet.sh

EXPOSE 3000
