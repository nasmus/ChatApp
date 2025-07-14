class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
    @users = User.where.not(id: current_user.id)
    #@groups = current_user.chat_rooms.where(chat_type: "group_chat").includes(:users)
    @groups = current_user.chat_rooms.where(chat_type: "group_chat").includes(chat_memberships: :user)
  end
end
