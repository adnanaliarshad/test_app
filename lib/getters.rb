module Getters

  include AstroCache::Interface

  protected

  def user_newsletter_subscriptions

    cache_name = "users_init_subscriptions_#{@current_user.arwen_id}"
    tags = %w{votigo users users-subscriptions}
    astro_cache(cache_name, :tags => tags, :expires_in => 80.minutes) do
      unless @current_user.arwen_id.blank?
        AppConfig['newsletters'].each do |k|
          subscription = Users::Arwen.subscriptions_to_newsletter(k, @current_user.arwen_id)
          @current_user.subscriptions[k.to_s] = subscription[0]
        end
      end
    end

  end

  def get_ivillage_form(params = {})

    cache_name = "session_ivillage_forms_#{params[:type]}"
    tags = %w{ivillage session session-ivillage-forms}
    astro_cache(cache_name, :tags => tags, :expires_in => 1.day) do
      unless params[:type].blank?
        if params[:type] == "login"
          IvillageForm.get_login_form({:flow_type => params[:flow_type], :vertical => params[:vertical]})
        elsif params[:type] == "forgot-password"
          IvillageForm.get_forgot_password_form({:flow_type => params[:flow_type], :vertical => params[:vertical]})
        elsif params[:type] == "register"
          IvillageForm.get_registration_form({:flow_type => params[:flow_type], :vertical => params[:vertical]})
        elsif params[:type] == "newsletter-list"
          IvillageForm.get_newsletter_list_form({:flow_type => params[:flow_type], :vertical => params[:vertical]})
        elsif params[:type] == "ask-for-email"
          IvillageForm.get_ask_for_email_form(params)
        elsif params[:type] == "ask-for-password"
          IvillageForm.get_ask_for_password_form(params)
        elsif params[:type] == "gigya-register"
          IvillageForm.get_gigya_register_form(params)
        elsif params[:type] == "thanks"
          IvillageForm.get_thanks_form(params)
        end
      end
    end

  end

end
