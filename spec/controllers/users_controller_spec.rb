require 'spec_helper'

describe UsersController do
  render_views

  I18n.available_locales.each do |locale|
    I18n.locale = locale
    
    describe "POST 'create' " do
      describe "success" do
        before(:each) do
          @attr = {
            :name => "New User",
            :email => "user@example.com",
            :password => "foobar",
            :password_confirmation => "foobar"
          }
        end
        
        it "should create a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end
        
        it "should redirect to the user show page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end
        
        it "should have a welcome message" do
          post :create, :user => @attr
          flash[:success] =~ /I18n.t(:flash_user_create_success)/n
        end
      end
      
      describe "failure" do
        before(:each) do
          @attr = {
            :name => "",
            :email => "",
            :password => "",
            :password_confirmation => ""
          }
        end
        
        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end
        
        before(:each) do
          post :create, :user => @attr
        end
        
        it "should have the right title" do
          response.should have_selector('title', :content => I18n.t(:title_user_new))
        end
        
        it "should render the 'new' page" do
          response.should render_template('new')
        end
      end
    end
    
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
        get :new
      end
    
      it "should be successful" do
        response.should be_success
      end
      
      it "should have the right title" do
        response.should have_selector('title', :content => I18n.t(:title_user_new))
      end
      
      it "should have a name field" do
        response.should have_selector("input[name='user[name]'][type='text']")
      end

      it "should have an email field" do
        response.should have_selector("input[name='user[email]'][type='text']")
      end

      it "should have a password field" do
        response.should have_selector("input[name='user[password]'][type='password']")
      end

      it "should have a password confirmation field" do
        response.should have_selector("input[name='user[password_confirmation]'][type='password']")
      end
    end
  end
end
