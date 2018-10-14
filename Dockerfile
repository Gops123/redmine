FROM rails

RUN mkdir -p /usr/src/ruby

RUN apt update
RUN apt-get install -y libffi-dev zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libmagickwand-dev libxml2 ruby-dev
#RUN service mysql start
WORKDIR /usr/src/ruby
RUN apt-get install postgresql-client
COPY . .
RUN  rm -rf ~/.bundle/ ~/.gem/ \
      && rm -rf Gemfile.lock \
      && rm -rf $GEM_HOME/bundler/ $GEM_HOME/cache/bundler/ \
      && rm -rf .bundle/ \
      &&  rm -rf vendor/cache/

RUN bundle install
RUN bundle install --without development test
RUN bundle install --without development test rmagick
#RUN service mysql start or service mysql start
RUN bundle exec rake generate_secret_token
#RUN service mysql start
RUN  bundle exec rake db:migrate RAILS_ENV="production"
RUN chown -R root:root files log tmp public/plugin_assets
RUN chmod -R 755 files log tmp public/plugin_assets

EXPOSE 3000
#CMD ["rails", "server", "-b", "0.0.0.0"]

