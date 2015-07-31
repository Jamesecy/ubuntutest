FROM ubuntu:12.04
MAINTAINER Ric Lister, ric@spreecommerce.com

## grab a nice friendly ruby package
ADD https://33a6871815e79f57702b-41c4a87573b0a371a9ac50d3802e995d.ssl.cf2.rackcdn.com/ruby2.0_2.0.0-p451_amd64.deb /tmp/
RUN dpkg -i /tmp/ruby2.0_2.0.0-p451_amd64.deb

## deps for build, then deps for bundle
RUN apt-get update && apt-get install -y \
    build-essential zlib1g-dev libreadline6-dev libyaml-dev libssl-dev \
    git libpq-dev libsqlite3-dev nodejs imagemagick

RUN gem install bundler --no-rdoc --no-ri

## cleanup to reduce images size
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## hack so docker can cache bundle if Gemfile has not changed
WORKDIR /app
ADD ./Gemfile /app/
ADD ./Gemfile.lock /app/
RUN bundle install 

## deploy code to /app
ADD ./ /app

## TODO: figure out how to do this without busting cache
RUN bundle exec rake assets:precompile --trace

## setup script for initial seeding database
## run this with docker run hub-demo ./setup.sh
RUN echo \
    "#!/bin/sh\n" \
    "rake railties:install:migrations\n" \
    "rake db:migrate\n" \
    "rake db:seed\n" \
    "rake spree_sample:load" > setup.sh && chmod 0755 setup.sh

## expose rails (for testing) and unicorn port
EXPOSE 3000 5000

## bundle exec all the things
ENTRYPOINT [ "bin/bundle", "exec" ]

CMD [ "foreman", "start" ]
