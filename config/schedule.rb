env :PATH, ENV['PATH']

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, lambda { "2>&1 | logger -t whenever_cron" }

set :chronic_options, hours24: true

every :day, at: '18:00', roles: [:app] do
  rake "shippify:trips:import:today"
end

every :day, at: '05:00', roles: [:app] do
  rake "shippify:places:import:all"
end

every :day, at: '15:00', roles: [:app] do
  rake "shippify:shippers:import:all"
end
