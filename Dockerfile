# Dockerfile
FROM seapy/rails-nginx-unicorn-pro:v1.1-ruby2.3.0-nginx1.8.1
MAINTAINER seapy(iamseapy@gmail.com)

# Add here your preinstall lib(e.g. imagemagick, mysql lib, pg lib, ssh config)
RUN apt-get update
RUN apt-get -qq -y install libmagickwand-dev imagemagick
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --force-yes libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN apt-get install -y pkg-config
RUN apt-get install -y libxml2-dev libxslt1-dev

#(required) Install Rails App
WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --without development test

COPY package.json package.json
COPY client/package.json client/package.json

RUN cd /tmp && npm install
RUN cd /tmp/client && npm install

WORKDIR /app
RUN bundle install --without development test

ADD . /app
WORKDIR /app
RUN cp -R /tmp/node_modules /app/node_modules && \
    cp -R /tmp/client/node_modules /app/client/node_modules
RUN cd client && npm install

#(required) nginx port number
EXPOSE 80

