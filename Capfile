# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "capistrano/rails"
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require "capistrano/bundler"
require "capistrano/puma"
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Workers  # if you want to control the workers (in cluster mode)
require "capistrano/inspeqtor"
require 'capistrano/maintenance'

require "whenever/capistrano"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
