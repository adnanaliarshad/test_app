module Middlewares
  class SetCookieDomain

    def initialize(app)
      @app = app
    end

    def call(env)
      host = env["HTTP_HOST"].to_s.split(':').first
      domain = if host
        case
          when host.include?("ivillage.com"); "www.ivillage.com"
          when host.include?("contest-www"); "contest-www.astrology.com"
          when host.include?("example.com"); host
          else; ".astrology.com"
        end
      else
        ".astrology.com"
      end
      env["rack.session.options"][:domain] = domain
      @app.call(env)
    end

  end
end
