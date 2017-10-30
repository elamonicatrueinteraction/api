FROM ruby:2.4-slim

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

ENV HOME /root
ENV APP_HOME /app
RUN mkdir $APP_HOME

ADD Gemfile* $APP_HOME/

RUN gem install bundler --no-ri --no-rdoc && \
    cd $APP_HOME; bundle install

EXPOSE 3030

WORKDIR $APP_HOME
