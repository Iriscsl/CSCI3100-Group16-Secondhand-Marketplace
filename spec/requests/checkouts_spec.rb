require 'rails_helper'

RSpec.describe "Checkouts", type: :request do
  let(:user) do
    u = User.new(
      name: "Test User",
      email: "1155088888@link.cuhk.edu.hk",
      password: "password123",
      password_confirmation: "password123"
    )
    u.skip_confirmation!
    u.save!
    u
  end

  let(:item) do
    Item.create!(
      title: "Used Textbook",
      description: "CSCI3100 textbook",
      price: 150,
      status: :available,
      community: :new_asia,
      user: user
    )
  end

  describe "POST /checkout" do
    context "when not signed in" do
      it "redirects to the sign-in page" do
        post checkout_path, params: { item_id: item.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "redirects with alert when item price is below minimum" do
        cheap_item = Item.new(
          title: "Cheap Item",
          description: "Too cheap",
          price: 3,
          status: :available,
          community: :new_asia,
          user: user
        )
        cheap_item.save(validate: false)

        post checkout_path, params: { item_id: cheap_item.id }
        expect(response).to redirect_to(item_path(cheap_item))
        expect(flash[:alert]).to match(/below the minimum/)
      end

      it "creates a Stripe Checkout Session and redirects" do
        fake_session = double("Stripe::Checkout::Session", url: "https://checkout.stripe.com/test")
        allow(Stripe::Checkout::Session).to receive(:create).and_return(fake_session)

        post checkout_path, params: { item_id: item.id }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to("https://checkout.stripe.com/test")
      end

      it "passes correct line_items to Stripe" do
        fake_session = double("Stripe::Checkout::Session", url: "https://checkout.stripe.com/test")

        expect(Stripe::Checkout::Session).to receive(:create).with(
          hash_including(
            payment_method_types: [ "card" ],
            mode: "payment",
            line_items: [ hash_including(
              price_data: hash_including(
                currency: "hkd",
                unit_amount: 15000,
                product_data: hash_including(name: "Used Textbook")
              ),
              quantity: 1
            ) ]
          )
        ).and_return(fake_session)

        post checkout_path, params: { item_id: item.id }
      end

      it "includes item and buyer metadata" do
        fake_session = double("Stripe::Checkout::Session", url: "https://checkout.stripe.com/test")

        expect(Stripe::Checkout::Session).to receive(:create).with(
          hash_including(
            metadata: hash_including(item_id: item.id, buyer_id: user.id)
          )
        ).and_return(fake_session)

        post checkout_path, params: { item_id: item.id }
      end
    end
  end

  describe "GET /checkout/success" do
    before { sign_in user }

    it "marks the item as sold" do
      get checkout_success_path(item_id: item.id)
      item.reload
      expect(item.status).to eq("sold")
    end

    it "returns a successful response" do
      get checkout_success_path(item_id: item.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /checkout/cancel" do
    before { sign_in user }

    it "does not change the item status" do
      get checkout_cancel_path(item_id: item.id)
      item.reload
      expect(item.status).to eq("available")
    end

    it "returns a successful response" do
      get checkout_cancel_path(item_id: item.id)
      expect(response).to have_http_status(:success)
    end
  end
end
