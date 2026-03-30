class ItemDigestMailer < ApplicationMailer
  default from: "fakeccy01@gmail.com"

  def daily_digest(user)
    @user = user
    @new_items = Item.where("created_at >= ?", 24.hours.ago).order(created_at: :desc)

    return if @new_items.empty?

    mail(
      to: @user.email,
      subject: "CUHK Marketplace Daily Digest - #{Date.current.strftime('%B %d, %Y')}"
    )
  end
end
