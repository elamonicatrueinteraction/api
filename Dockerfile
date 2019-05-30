FROM ruby:2.4.1-alpine

RUN apk update && apk add build-base libpq postgresql-dev libxml2-dev libxslt-dev git tzdata
RUN gem install bundler

WORKDIR /app
COPY Gemfile* ./
ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler && bundle install --without development test
COPY . .

EXPOSE 3030
ENV RAILS_ENV production
ENTRYPOINT ["rails", "s"]
