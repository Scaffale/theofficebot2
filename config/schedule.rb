# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
set :chronic_options, hours24: true

every :weekday, at: '7:15 am' do
  rake "gifs:optimize"
end
