class ChatRoomsController < ApplicationController
  def create_private_chat
    recipient = User.find(params[:user_id])

    chat = ChatRoom.joins(:chat_memberships)
               .where(chat_type: "private_chat")
               .group("chat_rooms.id")
               .having("COUNT(DISTINCT chat_memberships.user_id) = 2")
               .where(chat_memberships: { user_id: [current_user.id, recipient.id] })
               .first

    unless chat
      chat = ChatRoom.create(chat_type: "private_chat")
      chat.users << current_user
      chat.users << recipient
    end

    redirect_to chat_room_path(chat)
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages.order(:created_at)
    @message = Message.new
  end
end
