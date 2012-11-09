require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvillageForm do

  it "should return success for login form" do
    result = IvillageForm.get_login_form
    result.should_not be_empty
  end

  it "should return success for forgot password form" do
    result = IvillageForm.get_forgot_password_form
    result.should_not be_empty
  end

  it "should return success for registration form" do
    result = IvillageForm.get_registration_form
    result.should_not be_empty
  end

  it "should return success for newsletter form" do
    result = IvillageForm.get_newsletter_list_form
    result.should_not be_empty
  end

  it "should return success for gigya registration form" do
    result = IvillageForm.get_gigya_register_form
    result.should_not be_empty
  end

  it "should return success for thanks form" do
    result = IvillageForm.get_thanks_form
    result.should_not be_empty
  end

end
