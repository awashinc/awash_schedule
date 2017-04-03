FROM kaipark/ruby
MAINTAINER Kai Park <ggogun@gmail.com>


RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get update -qq && apt-get install -y libmysqlclient-dev

RUN mkdir /railsapp
WORKDIR /railsapp

ADD Gemfile /railsapp/Gemfile
ADD Gemfile.lock /railsapp/Gemfile.lock

# Occured not install rainbow Gem
# https://github.com/sickill/rainbow/issues/48#issuecomment-274266731
RUN gem update --system && \
gem update bundler

RUN bundle install

ADD . /railsapp

EXPOSE 3000

CMD ["/bin/bash", "/railsapp/bin/run_app"]
