require 'spec_helper'

describe PagesController do
  render_views
  before(:each) do
    @page_title = "KHSuite | "
  end

  describe "GET 'home'" do
    before do
      get 'home'
    end

    it "returns http success" do
      response.should be_success
    end
    
    it "should have the right title" do
      title = @page_title + I18n.t(:title_home)
      response.should have_selector('title', :content => title)
    end
  end

  describe "GET 'contact'" do
    before do
      get 'contact'
    end

    it "returns http success" do
      response.should be_success
    end
    
    it "should have the right title" do
      title = @page_title + I18n.t(:title_contact)
      response.should have_selector('title', :content => title)
    end
  end

  describe "GET 'about'" do
    before do
      get 'about'
    end

    it "returns http success" do
      response.should be_success
    end
    
    it "should have the right title" do
      title = @page_title + I18n.t(:title_about)
      response.should have_selector('title', :content => title)
    end
  end

  describe "GET 'help'" do
    before do
      get 'help'
    end
    
    it "returns http success" do
      response.should be_success
    end
    
    it "should have the right title" do
      title = @page_title + I18n.t(:title_help)
      response.should have_selector('title', :content => title)
    end
  end

  describe "GET 'tools'" do
    before do
      get 'tools'
    end

    it "returns http success" do
      response.should be_success
    end
    
    it "should have the right title" do
      title = @page_title + I18n.t(:title_tools)
      response.should have_selector('title', :content => title)
    end
  end

  describe "GET 'khplanner'" do
    before do
      get 'khplanner'
    end

    it "returns http success" do
      response.should be_success
    end
    
    it "should have the right title" do
      title = @page_title + I18n.t(:title_khplanner)
      response.should have_selector('title', :content => title)
    end
  end
end
