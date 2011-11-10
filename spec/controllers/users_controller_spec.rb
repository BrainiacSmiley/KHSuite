require 'spec_helper'

describe UsersController do
  render_views

  I18n.available_locales.each do |locale|
    I18n.locale = locale
    
    describe "GET 'show'" do
      before(:each) do
        @user = Factory(:user)
        get :show, :id => @user
      end
      
      it "should be successful" do
        response.should be_success
      end
      
      it "should find the right user" do
        assigns(:user).should == @user
      end
      
      it "should have the right title" do
        response.should have_selector('title', :content => @user.name)
      end
      
      it "should include the user's name" do
        response.should have_selector('h1', :content => @user.name)
      end      
    end

    describe "GET 'new'" do
      before(:each) do
        get 'new'
      end
    
      it "should be successful" do
        response.should be_success
      end
      
      it "should have the right title" do
        response.should have_selector('title', :content => I18n.t(:title_user_new))
      end
    end
  end
end
