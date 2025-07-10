class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
    @users = User.where.not(id: current_user.id)
  end
end
