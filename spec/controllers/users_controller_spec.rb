require 'spec_helper'

describe UsersController do
  render_views

  I18n.available_locales.each do |locale|
    I18n.locale = locale
    
    describe "DELETE 'destroy'" do
      before(:each) do
        @user = Factory(:user)
      end
      
      describe "as a non-signed-in user" do
        it "should deny access" do
          delete :destroy, :id => @user
          response.should redirect_to(signin_path)
        end
      end
      
      describe "as a non-admin user" do
        it "should protect the page" do
          test_sign_in(@user)
          delete :destroy, :id => @user
          response.should redirect_to(root_path)
        end
      end
      
      describe "as an admin user" do
        before(:each) do
          @admin = Factory(:user, :email => "admin@example.com", :admin => true)
          test_sign_in(@admin)
        end
        
        it "should destroy the user" do
          lambda do
            delete :destroy, :id => @user
          end.should change(User, :count).by(-1)
        end
        
        it "should display a success message" do
          delete :destroy, :id => @user
          flash[:success].should == I18n.t(:flash_user_deleted_success)
        end
        
        it "should not be able to delete himself" do
          lambda do
            delete :destroy, :id => @admin
          end.should_not change(User, :count)
          flash[:error].should == I18n.t(:flash_user_delete_himself)
        end
      end
    end
    
    describe "GET 'index'" do
      describe "for non-signed-in users" do
        it "should deny access" do
          get :index
          response.should redirect_to(signin_path)
          flash[:notice].should == I18n.t(:access_denied)
        end
      end
      
      describe "for signed-in users" do
        it "should protect the page" do
          test_sign_in(Factory(:user))
          get :index
          response.should redirect_to(root_path)
          flash[:error].should == I18n.t(:missing_rights)          
        end
      end
      
      describe "for admin users" do
        before(:each) do
          @admin = Factory(:user, :email => "admin@example.com", :admin => true)
          test_sign_in(@admin)
          second = Factory(:user, :name => "Bob", :email => "another@example.com")
          third  = Factory(:user, :name => "Ben", :email => "another@example.net")
          
          @users = [@admin, second, third]
          30.times do
            @users << Factory(:user, :email => Factory.next(:email))
          end
          get :index
        end
        
        it "should be succesful" do
          response.should be_success
        end
        
        it "should have the right title" do
          response.should have_selector('title', :content => I18n.t(:title_user_all))
        end
        
        it "should have an element for each user" do
          @users[0..2].each do |user|
            response.should have_selector('td', :content => user.name)
          end
        end
        
        it "should paginate users" do
          response.should have_selector('div.pagination')
          response.should have_selector('span.disabled', :content => I18n.t('paginate_test_prev'))
          response.should have_selector('a', :href => "/#{I18n.locale}/users?page=2", :content => "2")
          response.should have_selector('a', :href => "/#{I18n.locale}/users?page=2", :content => I18n.t('paginate_test_next'))
        end
        
        it "should have delete links for each user except themselfs" do
          @users[0..2].each do |user|
            if user != @admin
              response.should have_selector('a', :href => user_path(user), :content => "delete")            
            else
              response.should_not have_selector('a', :href => user_path(user), :content => "delete")            
            end
          end
        end
      end
    end
    
    describe "authentication of edit/update pages" do
      before(:each) do
        @user = Factory(:user)
      end
      
      describe "for signed-in users" do
        before(:each) do
          wrong_user = Factory(:user, :email => "user@example.net")
          test_sign_in(wrong_user)
        end
        
        it "should require matching users for 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end

        it "should require matching users for 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end
      end
      
      describe "for-nonsigned-in users" do
        it "should deny access to 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end
        
        it "shoudl deny acces to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end
      end
    end
    
    describe "PUT 'update" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      describe "failure" do
        before(:each) do
          @attr = {
            :name => "",
            :email => "",
            :password => "",
            :password_confirmation => ""
          }
          put :update, :id => @user, :user => @attr
        end
        
        it "should render the 'edit' page" do
          response.should render_template('edit')
        end
        
        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector('title', :content => I18n.t(:title_user_edit))
        end
      end
      
      describe "success" do
        before(:each) do
          @attr = {
            :name => "New Name",
            :email => "user@example.org",
            :password => "barbaz",
            :password_confirmation => "barbaz"
          }
          put :update, :id => @user, :user => @attr
        end
        
        it "should change the user's attributes" do
          @user.reload
          @user.name.should == @attr[:name]
          @user.email.should == @attr[:email]
        end
        
        it "should redirect to the user show page" do
          response.should redirect_to(user_path(@user))
        end
        
        it "should have a flash message" do
          flash[:success].should == I18n.t(:flash_user_edit_success)
        end
      end
    end
    
    describe "GET 'edit'" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        get :edit, :id => @user
      end
      
      it "should be successful" do
        response.should be_success
      end
      
      it "should have the right title" do
        response.should have_selector('title', :content => I18n.t(:title_user_edit))
      end
    end
    
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
          flash[:success].should == I18n.t(:flash_user_create_success)
        end
        
        it "should sign the user in" do
          post :create, :user => @attr
          controller.should be_signed_in
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
      end
      
      describe "for a non-signed-in user" do
        it "should redirect to signin page" do
          get :show, :id => @user
          response.should redirect_to(signin_path)
        end
      end
      
      describe "for a singed-in user" do
        before(:each) do
          test_sign_in(@user)
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
