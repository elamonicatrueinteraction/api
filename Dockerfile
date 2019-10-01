FROM ruby:2.4.1-alpine

RUN apk update && apk add build-base libpq postgresql-dev libxml2-dev libxslt-dev git tzdata
RUN gem install bundler

WORKDIR /app
COPY Gemfile* ./
COPY engines ./engines

ENV BUNDLER_VERSION 2.0.2
RUN gem install bundler:2.0.2 && bundle install --without development test cypress
COPY . .

EXPOSE 3030
ENV RAILS_ENV production
ENTRYPOINT ["rails", "s"]
