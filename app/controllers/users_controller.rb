class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = t(:title_user_new)
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = t(:flash_user_create_success)
      redirect_to @user
    else
      @title = t(:title_user_new)
      render 'new'
    end
  end
end
