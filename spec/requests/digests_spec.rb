require 'rails_helper'

RSpec.describe "Digests", type: :request do
  let(:user) do
    u = User.new(
      email: "1155033333@link.cuhk.edu.hk",
      password: "password123",
      password_confirmation: "password123"
    )
    u.skip_confirmation!
    u.save!
    u
  end

  describe "GET /digest" do
    context "when not signed in" do
      it "redirects to sign-in page" do
        get daily_digest_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "returns a successful response" do
        get daily_digest_path
        expect(response).to have_http_status(:success)
      end

      it "shows items created in the last 24 hours" do
        recent_item = Item.create!(
          title: "Recent Listing",
          description: "Brand new",
          price: 200,
          status: :available,
          community: :shaw,
          user: user,
          created_at: 6.hours.ago
        )

        get daily_digest_path
        expect(response.body).to include("Recent Listing")
      end

      it "does not show items older than 24 hours" do
        old_item = Item.create!(
          title: "Old Listing",
          description: "From last week",
          price: 50,
          status: :available,
          community: :united,
          user: user,
          created_at: 3.days.ago
        )

        get daily_digest_path
        expect(response.body).not_to include("Old Listing")
      end
    end
  end
end
