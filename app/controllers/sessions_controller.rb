class SessionsController < ApplicationController

  include UsersHelper

  def new
  end

  def redirection
    @redirect_url = request.env["HTTP_REFERER"]
    render :layout => false
  end

  def gigya_login
    result = Users::Ivillage.gigya_login(params)
    render :text => result.body
  end

  def social_email
    result = Users::Ivillage.social_email(params)
    render :text => result.body
  end

  def fetch_form
  end

  def create
    unless @current_user.arwen.uuid.blank?
      session[:sso_uuid] = @current_user.arwen.uuid
      cookies[:sso_uuid] = {:value => @current_user.arwen.uuid, :domain => "???.com", :path => "/"}
    else
      session[:sso_uuid] = nil
      cookies[:sso_uuid] = {:value => nil, :domain => "??.com", :path => "/"}
    end
    @api = Koala::Facebook::API.new(get_cookie_session_value(:access_token))
    begin
      @graph_data = @api.get_object("/me")
    rescue Exception=>ex
      puts ex.message
    end
    partial = '/framework/block/users/upload/b_users_upload'
    respond_to do |format|
      format.js do
        render :partial => partial, :locals => {
          :iv_arw => cookies[:sso_uuid]
        }
      end
    end
  end

  def destroy

  end

end
