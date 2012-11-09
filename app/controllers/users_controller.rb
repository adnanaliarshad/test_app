
class UsersController < ApplicationController

  include UsersHelper

  before_filter :init_newsletters

  def init_newsletters
    unless @current_user.arwen_id.blank?
      AppConfig['newsletters'].each do |k|
        subscription = Users::Arwen.subscriptions_to_newsletter(k,@current_user.arwen_id)
        @current_user.subscriptions[k.to_s] = subscription[0]
      end
    end
  end

  def new
    @browser_title = "Signing up"
    @iv_subsection1 = "entry"
    if params[:code]
      @@fb_oauth = Koala::Facebook::OAuth.new(@contest['fb'][Rails.env]['app_id'],
                                              @contest['fb'][Rails.env]['app_secret'],
                                              @contest['fb'][Rails.env]['callback'])
      access_token = @@fb_oauth.get_access_token(params[:code])
      @api = Koala::Facebook::API.new(access_token)
      begin
        @graph_data = @api.get_object("/me")
        @arwen_user_name = Users::Arwen.get_person_info({"email" => @graph_data['email']}, "username")
        Rails.logger.info "Facebook user data: #{@graph_data.inspect}"
      rescue Exception => ex
        Rails.logger.info "Error while getting Facebook user data: #{ex.message}"
      end
    end
  end

  def index
  end

  def welcome
    unless params[:code].nil?
      access_token = get_access_token
      set_cookie_session_value(:access_token, access_token)
    end
    @iv_subsection1 = "welcome"
  end

  def fb_redirect
    @iv_subsection1 = "welcome"
    @fb_url = "#{@contest['fb'][Rails.env]['redirect']}?code=#{params[:code]}"
    render :layout => false
  end

  def create
    #redirect_to users_path_builder(:users_new)
  end

  def newsletters
    result = Users::Ivillage.set_newsletters(params)
    render :text => result.body
  end

  def update
  end

  def update_user_info
  end

  def remote_validations
    result = {}
    params.each do |key, value|
      if value.is_a?(Hash)
        if key =~ /unique-email$/ || key =~ /existed-email$/
          result[key] = validate_email(key, value)
        elsif key =~ /unique-nick$/
          result[key] = validate_nick(key, value)
        elsif key =~ /correct-password$/
          result[key] = validate_password(key, value)
        end
      end
    end
   render :text => result.to_json
  end


  private

    def validate_email(key, value)
      result = Users::Arwen.existed_email?({"email" => value[:email], "uuid" => value[:uuid]})
      votigo = Users::Votigo.user_valid?({"email" => value[:email]})
      { :email_exists => result || votigo }
    end


    def validate_nick(key, value)
      result = Users::Arwen.existed_nick?({"nick" => value[:nick], "uuid" => value[:uuid]})
      { :nick_exists => result  }
    end

    def validate_password(key, value)
      password_correct = 'true'
      nick_changed = 'false'
      begin
        result = Users::Database.authenticate(value[:email], value[:password])
        nick_changed = (result[:nick_changed] ? 'true' : 'false')
      rescue Users::Database::InvalidEmail
        nil
      rescue Users::Database::InvalidPassword
        password_correct = 'false'
      end
      { :password_correct => password_correct, :nick_changed => nick_changed }
    end
end
