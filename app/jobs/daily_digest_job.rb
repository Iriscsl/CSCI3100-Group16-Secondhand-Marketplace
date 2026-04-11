class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    new_items = Item.where("created_at >= ?", 24.hours.ago)
    return if new_items.empty?

    User.find_each do |user|
      ItemDigestMailer.daily_digest(user).deliver_now
    end

    Rails.logger.info "[DailyDigest] Sent digest to #{User.count} users (#{new_items.count} new items)"
  end
end
