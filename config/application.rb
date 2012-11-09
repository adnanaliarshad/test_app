require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"

require 'yaml'
rails_root = File.expand_path(File.dirname(__FILE__) + '/..')

AppConfig = YAML.load_file("#{rails_root}/config/settings/application.yml")
CONTESTS = YAML.load_file("#{rails_root}/config/settings/contests.yml") unless Object.const_defined?("CONTESTS")
NEGATIVE_CAPTCHA_SECRET = "5765882a7b29679715bc8cab88de0cd7c7efc82e9b563fa22dedc40d8a29347c0b9639a76d29b0b1476a7a1f5dde7c1f3bbfe6f984a8e516511c9a2c5c4eb08a"
CACHE_CONFIG = YAML.load_file("#{rails_root}/config/settings/cache.yml") unless Object.const_defined?("CACHE_CONFIG")
if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Votigo
  SESSION_COOKIE_KEY = '_votigo_session'
  class Application < Rails::Application
    config.encoding = "utf-8"
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true
    config.middleware.insert_before "Rails::Rack::Logger", "AstroLogger::Middlewares::FinishLogging"
    # Enable the asset pipeline
    config.assets.enabled = true
    config.autoload_paths << "#{config.root}/lib"
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec
    end
    config.action_mailer.default_url_options = { :host => AppConfig['host'] }
  end
end

ActiveResource::Base.logger = Rails.logger
