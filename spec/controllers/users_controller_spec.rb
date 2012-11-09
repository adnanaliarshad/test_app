require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe UsersController do

  describe " - 200 XML - " do

    it "Should get new page" do
      get :new
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "Should get Index Page when no Code" do
      get :index
      response.header['Content-Type'].should include "text/html"
      response.should be_success
    end

    it "Should get Welcome Page" do
      get :welcome
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "Should get fb_redirect Page" do
      get :fb_redirect
      response.should be_success
      response.code.should == "200"
    end

    it "Should get newsletters" do
      get :newsletters, {}
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

  end

  describe " - 302 XML - " do

    it "Should Redirect Index Page to URL" do
      get :index, :code => "1221213dede"
      response.header['Content-Type'].should include "text/html"
      response.code.should == "302"
    end

  end

end