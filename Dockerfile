FROM rg.fr-par.scw.cloud/decidim/osp-decidim-base:latest

ENV USER_ID=1000 \
    GROUP_ID=2000 \
    RAILS_ENV=production \
    LANG=C.UTF-8 \
    BUNDLE_JOBS=20 \
    BUNDLE_RETRY=5 \
    APP_HOME=/usr/src/app/ \
    PATH=${APP_HOME}/bin:${PATH} \
    SECRET_KEY_BASE=dummy_key_base \
    GEM_HOME="/usr/local/bundle" \
    PATH=$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

USER root

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs

WORKDIR ${APP_HOME}

COPY --chown=decidim:decidim Gemfile Gemfile.lock ${APP_HOME}

USER decidim

RUN gem uninstall bundler \
    && gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)" \
    && bundle install

COPY --chown=decidim:decidim . ${APP_HOME}

RUN bundle exec rake assets:clobber assets:precompile

EXPOSE 3000
ENTRYPOINT ["./docker-entrypoint.sh"]
