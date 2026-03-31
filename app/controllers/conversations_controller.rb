class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = Conversation
    .where(buyer:current_user)
    .or(Conversation.where(seller: current_user))
    .includes(:buyer, :seller, :item, :messages)
    .order(updated_at: :desc)
  end

  def show
    @messages = @conversation.messages.order(:created_at)
    @message = @conversation.messages.build
  end

  def create
    @conversation = Conversation.find_or_create_by(
      item_id: params[:item_id],
      buyer_id: current_user.id,
      seller_id: params[:seller_id]
    )

    redirect_to conversation_path(@conversation)
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
end