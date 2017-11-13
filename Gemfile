source 'https://rubygems.org'

gem 'active_model_serializers', '~> 0.10.0'
gem 'bcrypt' # Ruby binding for the OpenBSD bcrypt() password hashing algorithm
gem 'jwt' # A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem 'oj' # A fast JSON parser and Object marshaller.
gem 'pg' # The PostgreSQL Adapter
gem 'puma', '~> 3.0' # Use Puma as the app server
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.0'
gem 'shippify-dash', git: "https://github.com/nilusorg/shippify-dash", branch: :master

group :development, :test do
  gem 'awesome_rails_console'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '~> 3.0.5'

  gem 'capistrano',             require: false
  gem 'capistrano-bundler',     require: false
  gem 'capistrano-inspeqtor',   require: false
  gem 'capistrano3-puma',       require: false
  gem 'capistrano-rails',       require: false
  gem 'capistrano-maintenance', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.0'
  # I use this repo because a missing feature in the Faker gem,
  # I already open a PR: https://github.com/stympy/faker/pull/1067
  gem 'faker', git: "https://github.com/agustin/faker", branch: :master, require: false
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
end
