class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @title = t(:title_user_new)
  end
end
