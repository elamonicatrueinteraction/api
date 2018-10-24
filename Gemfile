source 'https://rubygems.org'

gem 'active_model_serializers', '~> 0.10.0'
gem 'activerecord-postgis-adapter'
gem 'bcrypt' # Ruby binding for the OpenBSD bcrypt() password hashing algorithm
gem 'discard', '~> 1.0' # Soft deletes for ActiveRecord done right.
gem 'dry-types' # Is a simple and extendable type system for Ruby; useful for value coercions, applying constraints and other stuff
gem 'jwt' # A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem 'mercadopago-custom-checkout', require: 'mercadopago/custom_checkout' # A custom library in order to handle mercadopago custom checkout only
gem 'oj' # A fast JSON parser and Object marshaller.
gem 'pagy' # For paginating results that outperforms the others in each and every benchmark and comparison.
gem 'pg' # The PostgreSQL Adapter
gem 'pushme-aws', git: "git@github.com:nilusorg/pushme-aws", branch: :master # Push notifications through AWS SNS Mobile Push Notification Service
gem 'puma', '~> 3.0' # Use Puma as the app server
gem 'rack-attack'  # Rack middleware for blocking & throttling
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.1.0'
gem 'redis-namespace'
gem 'rgeo-geojson'
gem 'role_model'
gem 'rollbar' # Rollbar is an error tracking service for Ruby
gem 'sidekiq'
gem 'whenever', require: false
gem 'xlsxtream' # In order to be able to export and stream XLSX files

gem 'activeresource', '~> 5.0'

# This is important to be here at the bottom
gem 'api-pagination' # For pagination info in your headers, not in your response body.

gem 'dotenv-rails'

group :development, :test do
  gem 'rspec-rails', '~> 3.7'
  gem 'rubocop', require: false
end

group :development do
  gem 'capistrano',             require: false
  gem 'capistrano-bundler',     require: false
  gem 'capistrano-inspeqtor',   require: false
  gem 'capistrano3-puma',       require: false
  gem 'capistrano-rails',       require: false
  gem 'capistrano-maintenance', require: false

  gem 'guard-rspec', require: false

  gem 'httplog', require: false

  gem 'listen', '~> 3.0.5'

  gem 'rails-erd', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.0'
  # I use this repo because a missing feature in the Faker gem,
  # I already open a PR: https://github.com/stympy/faker/pull/1067
  gem 'faker'
  gem "json-schema"
  gem 'rails-controller-testing'
  gem 'rspec-collection_matchers'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
end
