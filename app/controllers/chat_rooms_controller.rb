class ChatRoomsController < ApplicationController
  before_action :ensure_user_is_member, only: [:show]
  before_action :set_chat_room, only: [:promote_to_moderator, :destroy, :admin_and_moderator_can_add_new_member, :show, :admin_remove_member, :update_group_name, :destroy_group_message]
  before_action :ensure_current_user_is_admin, only: [:promote_to_moderator, :admin_remove_member, :update_group_name]


  def create_private_chat
    recipient = User.find(params[:user_id])

    #check private chat exist or not
    chat = ChatRoom.joins(:chat_memberships)
               .where(chat_type: "private_chat")
               .group("chat_rooms.id")
               .having("COUNT(DISTINCT chat_memberships.user_id) = 2")
               .where(chat_memberships: { user_id: [current_user.id, recipient.id] })
               .first
    #if private chat is not exist then create it 
    unless chat
      chat = ChatRoom.create(chat_type: "private_chat")
      chat.users << current_user
      chat.users << recipient
    end

    redirect_to chat_room_path(chat)
  end

  #list of member excluding me for group chat
  def new_group
    @users = User.where.not(id :current_user.id)
  end

  #need to check hear any particular group exist or not

  # group chat create

  def create_group_chat
    selected_users_ids = params[:user_ids] || []
    chat_room = ChatRoom.create(chat_type: "group_chat", name: params[:group_name])
    # chat_room.users << current_user
    # chat_room.users << User.where(id: selected_users_ids)
    ChatMembership.create(user:current_user, chat_room: chat_room, chat_role: "admin")

    User.where(id:selected_users_ids).each do |user|
      ChatMembership.create(user: user, chat_room: chat_room, chat_role: "member")
    end
    redirect_to chat_room_path(chat_room)
  end

  #admin can make a new moderator

  def promote_to_moderator
    user_ids = params[:user_ids] || []
    if user_ids.any?
      # selected member should be moderator
      memberships = @chat_room.chat_memberships.where(user_id: user_ids, chat_role: :member)
      memberships.each do |membership|
        membership.update(chat_role: :moderator)
      end
      redirect_to chat_room_path(@chat_room), notice: "Selected members promoted to moderator."
    else
      redirect_to chat_room_path(@chat_room), alert: "No members selected."
    end
  end

  #delete chat group and deleted by only admin
  def destroy
    admin_Check = @chat_room.chat_memberships.find_by(user_id: current_user.id, chat_role: :admin)
    if admin_Check
      @chat_room.destroy
      redirect_to root_path, notice:"group delete successfully"
    else
      redirect_to root_path, alert:"only admin can delete this group"
    end
  end

  #admin and modertor add new member to there chat group
  def admin_and_moderator_can_add_new_member
    current_user_membership = @chat_room.chat_memberships.find_by(user_id: current_user.id)
    unless current_user_membership&.admin? || current_user_membership&.moderator?
      redirect_to chat_room_path(@chat_room), notice:"only admin and moderator can add new member"
    end
    user_ids = params[:user_ids] || []

    user_ids.each do |user_id|
      ChatMembership.create(user_id: user_id, chat_room_id: @chat_room.id, chat_role: :member)
    end
    redirect_to chat_room_path(@chat_room), notice: "selected user havebeen created to this group" 
  end

  def admin_remove_member
    membership = @chat_room.chat_memberships.find_by(user_id: params[:user_id])
    user_ids = params[:user_ids] || []
    user_ids.each do |user_id|
      membership = @chat_room.chat_memberships.find_by(user_id: user_id)
      membership.destroy if membership && !membership.admin?
    end
    redirect_to chat_room_path(@chat_room), notice: "member is successfully deleted"
  end

  def update_group_name

  end

  def destroy_group_message
    @message = Message.find(params[:message_id])
    @chat_room = @message.chat_room

    admin_membership = @chat_room.chat_memberships.find_by(user_id: current_user.id)

    if admin_membership&.admin? || admin_membership&.moderator?
      @message.destroy
      redirect_to chat_room_path(@chat_room), notice: "Message deleted successfully."
    else
      redirect_to chat_room_path(@chat_room), alert: "Only admins can delete messages."
    end
  end


  def show
    @messages = @chat_room.messages.order(:created_at)
    @message = Message.new
    @members_for_promotion = ChatMembership.where(chat_room_id: @chat_room.id, chat_role: ChatMembership.chat_roles[:member]).includes(:user)
    @members_not_in_groups = User.where.not(id: @chat_room.users.pluck(:id))
    admin_membership = @chat_room.chat_memberships.find_by(user_id: current_user.id)
    @current_member_is_admin = admin_membership&.admin?
    @current_member_is_moderator = admin_membership&.moderator?
  end

  

  private 
    #can't access any other chat
    def ensure_user_is_member
      @chat_room = ChatRoom.find(params[:id])
      unless @chat_room.users.include?(current_user)
        flash[:alert] = "You are not authorized to access this chat."
        redirect_to root_path
      end
    end

    # find chat room id and store is chat_room variable 
    def set_chat_room
      @chat_room = ChatRoom.find(params[:id])
    end


    #cureent user is admin or not
    def ensure_current_user_is_admin
      admin_membership = @chat_room.chat_memberships.find_by(user_id: current_user.id)
        unless admin_membership&.admin?
          redirect_to chat_room_path(@chat_room), alert: "Only admins can do this."
        return
      end
    end

end
