# Sometimes there can be issue when there are two session variables with different
# domains but the same name are presented in cookies. Then, sometimes session's
# saving doesn't work at all. Here, we are trying to find and delete second session
# variable (which usually has domain = 'www.astrology.com', now '.astrology.com')
module Middlewares
  class ClearDuplicatedSession

    def initialize(app)
      @app = app
    end

    def call(env)
      unless session_can_be_demarshalized?(env)
        clear_the_session_cookie(env)
      end

      result = @app.call(env)

      if there_are_more_than_one_session_key_in_cookies?(env)
        delete_session_cookie_for_current_domain(env)
      end

      result
    end


    private

      # After migrating from Ruby 1.8.7 to Ruby 1.9.2 Date class was changed, it doesn't
      # have the _load method anymore. But some users can have Date in their session (we
      # saved Date objects in session[:yhooca] before, now we save only strings,
      # but some users still can have Date objects in sessions).
      # If we try to load old Date object by Marshal, we will get an exception.
      # To fix that, we'll try to do that, and if it fails - clear the session.
      def session_can_be_demarshalized?(env)
        unless env["HTTP_COOKIE"].blank?
          session_match = CGI.unescape(env["HTTP_COOKIE"]).to_s.match(/#{Votigo::SESSION_COOKIE_KEY}=([^;]*);/)
        end
        if session_match
          begin
            Marshal.load(Base64.decode64(session_match[1]))
          rescue
            return false
          end
        end
        true
      end

      def clear_the_session_cookie(env)
        env["HTTP_COOKIE"].to_s.gsub!(/#{Votigo::SESSION_COOKIE_KEY}=[^;]*;/, "")
      end

      def there_are_more_than_one_session_key_in_cookies?(env)
        entries = 0
        offset = 0
        while offset = env["HTTP_COOKIE"].to_s.index(get_session_key(env), offset)
          entries += 1
          offset += 1
        end
        entries > 1
      end


      def delete_session_cookie_for_current_domain(env)
        ::Rack::Utils.set_cookie_header!(env['action_controller.instance'].response.header, get_session_key(env),
          :value => '', :path => '/', :expires => Time.at(0)
        )
      end


      def get_session_key(env)
        env['rack.session'].instance_variable_get("@by").instance_variable_get("@key")
      end

  end
end
