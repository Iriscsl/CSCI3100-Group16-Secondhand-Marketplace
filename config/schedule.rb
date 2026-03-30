# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#
# Update crontab with: whenever --update-crontab
# Clear crontab with:  whenever --clear-crontab

set :output, "log/cron.log"
set :environment, "production"

every 1.day, at: "8:00 am" do
  rake "digest:send"
end
