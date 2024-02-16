class MessagesController < ApplicationController
  before_action :ensure_that_signed_in

  def index
    @messages = Message.all
  end

  def show
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend("messages", partial: "message", locals: { message: @message })
        }
        format.html { redirect_to messages_url }
        format.json { render :index, status: :created, location: @messages }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id)
  end
end
