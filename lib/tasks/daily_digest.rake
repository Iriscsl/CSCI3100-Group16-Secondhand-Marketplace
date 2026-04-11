namespace :digest do
  desc "Send daily digest email with new items from the last 24 hours"
  task send: :environment do
    DailyDigestJob.perform_now
  end
end
