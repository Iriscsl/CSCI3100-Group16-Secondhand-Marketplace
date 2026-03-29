class MessagesController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_conversation 

  def create
    @message = @convesration.messages.build(message_params)
    @message.sender = current_user 

    if @message.save 
      redirect_to conversation_path(@convesration), notice: "Message sent." 
    else 
      @messages = @conversation.messages.order(:created_at) 
      render "conversations/show", status: :unprocessable_entity 
    end 
  end

  private

  def set_conversation 
    @convesrsation = Conversation.find(params[:conversation_id])
  end

  def message_params 
    params.require(:message).permit(:content)
    # make sure only accepting { message: {content: "helllo"} }
  end
end
