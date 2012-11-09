class Users::Ivillage

  extend AstroModels::HttpRequest
  extend AstroModels::AstroErrorReporter
  attr_accessor :arwen_id, :username, :token

  def initialize(options = {})
    @arwen_id = options["person_id"] unless options["person_id"].blank?
    @username = options["nick"] unless options["username"].blank?
    @token = options["token"] unless options["token"].blank?
  end

  #http://www.ivillage.com/ajax/user/sign-in
  def self.login(params)
    prefix = "/ajax/user/sign-in"
    options = { :prefix => prefix, :site => User.ivillage_server}
    self.http_post_request(params, options)
  end

  #http://www.ivillage.com/ajax/user/sign-in
  def self.register(params)
    prefix = "/ajax/user/sign-up"
    options = { :prefix => prefix, :site => User.ivillage_server}
    self.http_post_request(params, options)
  end

  #http://www.ivillage.com/ajax/user/sign-in
  def self.gigya_login(params)
    prefix = "/ajax/gigya/login"
    options = { :prefix => prefix, :site => User.ivillage_server}
    self.http_post_request(params, options)
  end

  def self.social_email(params)
    prefix = "/ajax/social/email"
    options = { :prefix => prefix, :site => User.ivillage_server}
    self.http_post_request(params, options)
  end

  #http://www.ivillage.com/ajax/gigya/register
  def self.gigya_register(params)
    prefix = "/ajax/gigya/register"
    options = { :prefix => prefix, :site => User.ivillage_server}
    self.http_post_request(params, options)
  end

  #http://www.ivillage.com/ajax/user/set-newsletters
  def self.set_newsletters(params)
    prefix = "/ajax/user/set-newsletters"
    options = { :prefix => prefix, :site => User.ivillage_server}
    self.http_post_request(params, options)
  end

  #http://www.ivillage.com/ajax/user/sign-out
  def self.logout(params)
    prefix = "/ajax/user/sign-out"
    options = { :prefix => prefix, :site => User.ivillage_server}
    self.http_post_request(params, options)
  end

end