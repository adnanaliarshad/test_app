require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe SlidesController do

  describe " - 200 XML - " do
    it "should get slideshow page" do
      get :index
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "should get gallery page" do
      get :gallery
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "should get next_page" do
      get :next_page, {:sort => "created",
                       :direction => "desc",
                       :limit => "6",:page_no => "1"
                      }
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "should get single slide page" do
      get :slide, :id => '780532'
      response.should be_success
      response.header['Content-Type'].should include "text/html"
    end

    it "should get next single slide page with JSON" do
      get :next_slide, :id => '780532'
      response.should be_success
    end

    it "should get next single slides page with JSON" do
      get :next_slides
      response.should be_success
      response.header['Content-Type'].should include "application/json"
    end

    it "should get add_vote with JSON" do
      get :vote_entry
      response.should be_success
      response.header['Content-Type'].should include "application/json"
    end


  end

end