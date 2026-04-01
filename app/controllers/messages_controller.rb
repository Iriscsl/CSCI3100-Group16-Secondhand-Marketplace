class MessagesController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_conversation  
  before_action :authorize_participant!

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_user 

    if @message.save 
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to conversation_path(@conversation), notice: "Message sent." }
      end 
    else 
      @messages = @conversation.messages.order(:created_at) 
      render "conversations/show", status: :unprocessable_entity 
    end 
  end

  private

  def set_conversation 
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params 
    params.require(:message).permit(:body)
  end
  def authorize_participant!
    unless current_user == @conversation.buyer || current_user == @conversation.seller
      redirect_to conversations_path, alert: "You are not allowed to access this conversation."
    end
  end
end
