require "rails_helper"

RSpec.describe "Confirmations", type: :request do
  let(:user) do
    User.create!(
      email: "1155000300@link.cuhk.edu.hk",
      password: "password",
      name: "Unconfirmed User"
    )
  end

  describe "GET /users/confirmation (show)" do
    it "does NOT auto-confirm the user" do
      token = user.confirmation_token

      get user_confirmation_path, params: { confirmation_token: token }

      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.confirmed_at).to be_nil
    end

    it "renders the confirmation landing page with a button" do
      token = user.confirmation_token

      get user_confirmation_path, params: { confirmation_token: token }

      expect(response.body).to include("Confirm my account")
      expect(response.body).to include(token)
    end

    it "renders an error when confirmation_token is blank" do
      get user_confirmation_path, params: { confirmation_token: "" }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /users/confirm_account (confirm)" do
    it "confirms the user with a valid token" do
      token = user.confirmation_token

      post confirm_user_path, params: { confirmation_token: token }

      user.reload
      expect(user.confirmed_at).not_to be_nil
      expect(response).to redirect_to(new_user_session_path)
    end

    it "does not confirm with an invalid token" do
      post confirm_user_path, params: { confirmation_token: "bad-token" }

      user.reload
      expect(user.confirmed_at).to be_nil
    end

    it "does not confirm an already confirmed user's token twice erroneously" do
      user.confirm
      old_confirmed_at = user.confirmed_at

      post confirm_user_path, params: { confirmation_token: "expired-token" }

      user.reload
      expect(user.confirmed_at).to eq(old_confirmed_at)
    end
  end
end
