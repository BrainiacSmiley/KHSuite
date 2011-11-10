class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @title = t(:title_user_new)
  end
end
