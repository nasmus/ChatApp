class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
    #without current user
    @users = User.where.not(id: current_user.id)
    # group chat a current user er data
    @groups = current_user.chat_rooms.where(chat_type: "group_chat").includes(chat_memberships: :user)
  end
end
