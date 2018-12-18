require 'simplecov'
require 'simplecov-json'
SimpleCov.use_merging true
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::HTMLFormatter
])
SimpleCov.minimum_coverage 40
SimpleCov.start do
  add_filter 'spec'
  add_filter 'config'
  add_group "Controllers", "app/controllers"
  add_group "Channels", "app/channels" if defined?(ActionCable)
  add_group "Models", "app/models"
  add_group "Mailers", "app/mailers"
  add_group "Helpers", "app/helpers"
  add_group "Jobs", %w[app/jobs app/workers]
  add_group "Libraries", "lib/"

  track_files "{app,lib}/**/*.rb"
end

require 'support/faker'
require 'database_cleaner'

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'webmock/rspec'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# require 'support/shoulda_matchers'
# require 'support/factory_bot'
# require 'support/database_cleaner'
# require 'support/request_helpers'
# require 'support/api_shared_context'
# require 'support/api_schema_matcher'
# require 'support/sidekiq'

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
end
