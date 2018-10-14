FROM ruby

RUN mkdir -p /usr/src/ruby

RUN apt update
WORKDIR /usr/src/ruby
COPY . .
RUN bundle install
RUN bundle install --without development test 
RUN bundle install --without development test rmagick
#RUN service mysql start or service mysql start 
RUN bundle exec rake generate_secret_token
#RUN  bundle exec rake db:migrate RAILS_ENV="production"
RUN chown -R root:root files log tmp public/plugin_assets 
RUN chmod -R 755 files log tmp public/plugin_assets

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
