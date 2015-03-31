# Docker File to generate a dev enviroment
#
# To execute it install docker and then run 'docker build .'
#
FROM ruby:2.0.0

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_VERSION 4.0.0
RUN gem install rails --version "$RAILS_VERSION"

ADD Gemfile.lock /tmp/Gemfile.lock
ADD Gemfile /tmp/Gemfile

RUN cd /tmp && bundle install

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
