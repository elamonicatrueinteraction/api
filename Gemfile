source 'https://rubygems.org'

gem 'bcrypt' # Ruby binding for the OpenBSD bcrypt() password hashing algorithm
gem 'jwt' # A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem 'pg' # The PostgreSQL Adapter
gem 'puma', '~> 3.0' # Use Puma as the app server
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.0'

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '~> 3.0.5'

  gem 'capistrano',           require: false
  gem 'capistrano-bundler',   require: false
  gem 'capistrano-inspeqtor', require: false
  gem 'capistrano3-puma',     require: false
  gem 'capistrano-rails',     require: false
end

group :test do
  gem 'factory_bot_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
end
