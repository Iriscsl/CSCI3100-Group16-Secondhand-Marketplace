require 'rails_helper'

RSpec.describe ItemDigestMailer, type: :mailer do
  let(:user) do
    u = User.new(
      name: "Test User",
      email: "1155022222@link.cuhk.edu.hk",
      password: "password123",
      password_confirmation: "password123"
    )
    u.skip_confirmation!
    u.save!
    u
  end

  describe "#daily_digest" do
    context "when there are new items" do
      before do
        Item.create!(
          title: "Test Item",
          description: "A test listing",
          price: 80,
          status: :available,
          community: :chung_chi,
          user: user,
          created_at: 2.hours.ago
        )
      end

      let(:mail) { ItemDigestMailer.daily_digest(user) }

      it "sends to the correct user" do
        expect(mail.to).to eq([ "1155022222@link.cuhk.edu.hk" ])
      end

      it "sends from the team email" do
        expect(mail.from).to eq([ "csci3100gp16team@gmail.com" ])
      end

      it "has the correct subject with today's date" do
        expected_date = Date.current.strftime('%B %d, %Y')
        expect(mail.subject).to eq("CUHK Marketplace Daily Digest - #{expected_date}")
      end

      it "includes the item title in the body" do
        expect(mail.body.encoded).to include("Test Item")
      end

      it "includes the item price in the body" do
        expect(mail.body.encoded).to include("80")
      end
    end

    context "when there are no new items" do
      before do
        Message.delete_all
        Conversation.delete_all
        Item.delete_all
      end

      it "returns nil (no email sent)" do
        mail = ItemDigestMailer.daily_digest(user)
        expect(mail.message).to be_a(ActionMailer::Base::NullMail)
      end
    end
  end
end
