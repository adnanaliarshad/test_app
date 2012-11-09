require "coffee-filter"

class ApplicationController < ActionController::Base

    protect_from_forgery
    include AstroCache::Interface
    before_filter :init_user
    layout :set_layout


    def init_user

      Rails.logger.info("Request.host #{request.host} ==== User SSO UUID =========== #{session[:sso_uuid]} == Cookies ====#{cookies[:sso_uuid]}")
      @@fb_oauth = nil
      sso_uuid = session[:sso_uuid].blank? ? "" : session[:sso_uuid]
      sso_uuid = sso_uuid.blank? && cookies[:sso_uuid].blank? ? "" : cookies[:sso_uuid]
      username = cookies['iv_id'].nil? ? "" : cookies['iv_id']
      url = request.url + "/" unless request.url.last == "/"
      contest = url.match(/photo-contests\/.*?\//).to_s.split("/")[1].split("?")[0]
      set_contest_values(contest)
      cache_name = "application_init_user_#{sso_uuid}_#{username}_#{@contest_name}"
      tags = %w{votigo application application-init}
      @current_user =  astro_cache(cache_name, :tags => tags, :expires_in => 80.minutes) do
        @current_user =   User.find({"uuid" => sso_uuid, "username" => username, :contest => contest})
      end

    end

    def set_layout
      if params[:signed_request].nil? and params[:facebook].nil?
        'application'
      else
        'facebook'
      end
    end

    def set_cookies(result)
      resp = result['set-cookie'].dup.split(',')
      resp.each do |v|
        a = v.dup
        v = v.split("\;").first.split("=")
        value = v.last
        key = v.first.strip
        cookies[key] = {:value => value, :domain => "ivillage.com", :path => "/"}
      end
    end

    def get_cookie_session_value(key)
      session_value = session[key]
      cookie_value = cookies[key]
      return_value = nil
      return_value = session_value unless session_value.nil?
      return_value = cookie_value unless cookie_value.nil?
      if return_value.nil? && !params[:code].nil?
        return_value = get_access_token
        set_cookie_session_value(:access_token, return_value)
      end
      return_value
    end

    def set_cookie_session_value(key,value)
      session[key] = value
      cookies[key] = value
    end

    def get_access_token
      @@fb_oauth = Koala::Facebook::OAuth.new(@contest['fb'][Rails.env]['app_id'],
                                              @contest['fb'][Rails.env]['app_secret'],
                                              @contest['fb'][Rails.env]['callback'])
      @@fb_oauth.get_access_token(params[:code])
    end

    def set_contest_values(contest = nil)
      @contest = CONTESTS["contests"][contest]
      @contest_id = @contest['contest_id'][Rails.env]
      @contest_name = @contest['name']
    end

end