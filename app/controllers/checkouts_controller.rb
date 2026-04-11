class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])

    if @item.price < 4
      redirect_to @item, alert: "This item's price is below the minimum ($4 HKD) required for checkout." and return
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: [ {
        price_data: {
          currency: "hkd",
          product_data: {
            name: @item.title,
            description: @item.description.to_s.truncate(500)
          },
          unit_amount: @item.price * 100
        },
        quantity: 1
      } ],
      mode: "payment",
      success_url: checkout_success_url(item_id: @item.id),
      cancel_url: checkout_cancel_url(item_id: @item.id),
      metadata: {
        item_id: @item.id,
        buyer_id: current_user.id
      }
    )

    redirect_to session.url, allow_other_host: true, status: :see_other
  end

  def success
    @item = Item.find(params[:item_id])
    @item.update(status: :sold)
  end

  def cancel
    @item = Item.find(params[:item_id])
  end
end
