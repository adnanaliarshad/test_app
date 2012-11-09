# Use older YAML parser because newer one doesn't keep all functionality and threw errors.
# All YAML looked good on site when checked with YAML.load_file
# See: http://stackoverflow.com/questions/4980877/rails-error-couldnt-parse-yaml
# TODO: Revisit when Psych matures.
require 'yaml'
YAML::ENGINE.yamler= 'syck'

require 'rubygems'

# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)
