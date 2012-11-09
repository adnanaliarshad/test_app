require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe SessionsController do

  describe " - 200 XML - " do

    it "Should get New Page" do
      get :new, {
                  :sso_email_username => "abc@xyz.com",
                  :sso_password => "12345678"
                }
      response.header['Content-Type'].should include "text/html"
    end

    it "Should get Create Page" do
      get :create
      response.header['Content-Type'].should include "text/html"
    end

    it "Should sign out current user" do
      get :destroy
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "Should get Sign out message after Sign out" do
      get :destroy
      response.should be_success
      response.body == "You have been logged out."
      response.header['Content-Type'].should include "text/html"
    end

    it "Should return valid Social Email for new email" do
      get :social_email, { :email => "abc@xyz.com" }
      response.should be_success
      response.header['Content-Type'].should include "text/html"
      JSON.parse(response.body)["valid"].should be_true
    end

    it "Should return valid Social Email for valnew email" do
      get :gigya_login, { :email => "abc@xyz.com", :password => "1234678" }
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "Should redirect page to Given url" do
      get :redirection
      response.should be_true
      response.header['Content-Type'].should include "text/html"
    end

  end

end