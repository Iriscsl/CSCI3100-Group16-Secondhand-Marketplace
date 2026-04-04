class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [ :show ]
  before_action :authorize_participant!, only: [ :show ]

  def index
    @conversations = Conversation
    .where(buyer: current_user)
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

    if @conversation.save 
      redirect_to conversation_path(@conversation) 
    else 
      redirect_to items_path, alert: @conversation.errors.full_messages.to_sentence 
    end 
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
  def authorize_participant!
    unless current_user == @conversation.buyer || current_user == @conversation.seller
      redirect_to conversations_path, alert: "You are not allowed to view this conversation."
    end
  end
end
