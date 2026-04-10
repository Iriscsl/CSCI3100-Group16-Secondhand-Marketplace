require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:user) do
    u = User.new(
      name: "Test User",
      email: "1155011111@link.cuhk.edu.hk",
      password: "password123",
      password_confirmation: "password123"
    )
    u.skip_confirmation!
    u.save!
    u
  end

  describe "#perform" do
    context "when there are new items in the last 24 hours" do
      before do
        Item.create!(
          title: "Fresh Item",
          description: "Just listed",
          price: 50,
          status: :available,
          community: :shaw,
          user: user,
          created_at: 1.hour.ago
        )
      end

      it "sends a digest email to each user" do
        mail_double = double("mail", deliver_now: true)
        expect(ItemDigestMailer).to receive(:daily_digest).with(user).and_return(mail_double)

        DailyDigestJob.perform_now
      end

      it "logs the send count" do
        allow(ItemDigestMailer).to receive_message_chain(:daily_digest, :deliver_now)

        DailyDigestJob.perform_now

        log_output = File.read(Rails.root.join("log", "test.log"))
        expect(log_output).to include("[DailyDigest] Sent digest to 1 users (1 new items)")
      end
    end

    context "when there are no new items" do
      it "does not send any emails" do
        expect(ItemDigestMailer).not_to receive(:daily_digest)

        DailyDigestJob.perform_now
      end
    end

    context "when items are older than 24 hours" do
      before do
        Item.create!(
          title: "Old Item",
          description: "Listed long ago",
          price: 100,
          status: :available,
          community: :united,
          user: user,
          created_at: 2.days.ago
        )
      end

      it "does not send any emails" do
        expect(ItemDigestMailer).not_to receive(:daily_digest)

        DailyDigestJob.perform_now
      end
    end
  end

  describe "queue" do
    it "is queued in the default queue" do
      expect(DailyDigestJob.new.queue_name).to eq("default")
    end
  end
end
