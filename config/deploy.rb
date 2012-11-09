# The procedure of deploying Metis to production:
#
# 1. Deploy to devlnx1 and stagger, run tests there to make sure everything works
#   cap CAP_USER=your_user_on_server devlnx1 deploy
#   cap CAP_USER=your_user_on_server stagger deploy
#   ssh to devlnx1, stagger
#   cd /home/httpd/h.astrology.com/htdocs/content/current
#   rake spec
#
# 2. Deploy to app1 and public
#   cap CAP_USER=your_user_on_server production deploy
#
# It actually will only run such command:
#
#   $ date > /home/httpd/h.astrology.com/htdocs/content/RELEASEME"
#
# Then, that change of the RELEASEME file will be noticed, and the app will be rsynced
# from stagger to app1 (metis.astrology.com) and to serv1, serv3 and serv4 (content.astrology.com).
# After rsyncing, the /home/httpd/h.astrology.com/htdocs/content/current/RELEASEME-post script
# will be executed, which restarts delayed_job workers and set correct server_specific
# config files



# Votigo deploy:
# cap CAP_USER=username TAG=develop stagger deploy
# cap CAP_USER=username production deploy

if ENV['CAP_USER']
  set :user, ENV['CAP_USER']
else
  set(:user, Capistrano::CLI.ui.ask('Act as user: '))
end

set :application, "votigo"
set :repository, "git@mitosis.astrology.com:votigo.git"

set :scm, "git"
set :branch, ENV['BRANCH'] || ENV['TAG'] || "master"
set :deploy_via, :export
set :app_version, (`git fetch origin master && git log origin --pretty=format:'' | wc -l`.to_s.strip rescue nil)
ssh_options[:forward_agent] = true
set :use_sudo, false
set :ruby, '/opt/ruby/bin/ruby'
set :bundle, '/opt/ruby/bin/bundle'
set :rake, "#{bundle} exec rake"
default_environment["PATH"] = "$PATH:/opt/ruby/bin"
default_environment["LANG"] = "en_US.UTF-8"

# Set destinations
task :stagger do
  set :application, "contest-www"
  set :server_id, 'stagger'
  set :server_type, 'stagger'
  set :rails_env, ENV['RAILS_ENV'] || 'production'
  set :server_name, "http://#{application}.stagger.colo.astrology.com:8887/"
  set :deploy_to, "/home/httpd/h.astrology.com/htdocs/#{application}"
  server "stagger.colo.astrology.com", :app, :web, :primary => true
end
task :production_stage do
  set :application, "contest-www"
  set :server_id, 'stagger'
  set :server_type, 'stage'
  set :rails_env, 'production'
  set :server_name, "http://#{application}.stagger.colo.astrology.com:8887/"
  set :deploy_to, "/home/httpd/h.astrology.com/htdocs/#{application}"
  server "stagger.colo.astrology.com", :app, :web, :primary => true
end
task :production do
  set :application, "contest-www"
  set :server_id, 'public'
  set :server_type, 'production'
  set :deploy_to, "/home/httpd/h.astrology.com/htdocs/#{application}"
  set :server_name, "http://#{application}.astrology.com/"
  server "stagger.colo.astrology.com", :app, :web, :primary => true
end


desc 'Restart Apache FastCGI processes.'
task :restart_fastcgi, :roles => :app do
  run "sudo -u apache /usr/bin/pkill -9 -u apache dispatch.fcgi"
end

desc 'Restart Apache Passenger app.'
task :restart_passenger, :roles => :app do
  run "touch #{current_path}/tmp/restart.txt"
end

desc 'Restart Apache self-service.'
task :restart_apache, :roles => :app do
  run "sudo /sbin/service apachectl-astro-httpd-rb stop"
  run "sleep 3"
  run "sudo /sbin/service apachectl-astro-httpd-rb start"
end

desc "Publish the staging server to mirror of public server"
task :deploy_to_test_public, :roles => :app do
  run "/opt/astro/bin/xfer-rails.sh -p -r #{application}"
end

desc "Install gems by bundle"
task :install_gems_by_bundler, :roles => :app do
  run "BUNDLE_GEMFILE=#{release_path}/Gemfile #{bundle} config build.mysql2 --with-mysql-config=/opt/astro-mysql-rb/bin/mysql_config"
  run "BUNDLE_GEMFILE=#{release_path}/Gemfile #{bundle} config build.nokogiri --with-xml2-include=/opt/libxml2/include/libxml2 --with-xml2-lib=/opt/libxml2/lib --with-xslt-dir=/opt/libxslt"
  run "BUNDLE_GEMFILE=#{release_path}/Gemfile #{bundle} install --deployment"
end

desc "Clear cache using 'rake RAILS_ENV=[environment] cache:clear'"
task :clear_cache, :role => :app do
  STDERR.puts "*** FYI: Cache can be guaranteed cleared by updating cache version in config/cache.yml"
  if %w{stage dev qa}.include?(server_type)
    run "cd #{current_path} && #{rake} RAILS_ENV=#{rails_env} cache:clear"
    STDERR.puts "*** Cache cleared with: rake RAILS_ENV=production cache:clear"
    STDERR.puts "*** On stage, if this doesn't work, try: 'telnet localhost 11411', then 'flush_all', then ctl-rightbracket, then 'quit'"
  end
end


after 'deploy:update_code', :post_update_code
after "deploy:update", "add_symlinks"
after "deploy:setup", "initial_setup"
after "deploy:restart", :clear_cache

namespace :deploy do

  desc <<-DESC
    Deploys your project. This calls both `update' and `restart'. When server is \
    `public', this only runs the sync script between the staging and public servers.
  DESC
  task :default do
    case server_id
    when 'public'
      run "date > #{deploy_to}/RELEASEME"
    else
      update
      restart
    end
  end

  desc "Run the full tests on the currently deployed app."
  task :run_current_tests do
   run "cd #{current_path} && rake spec"
  end

  desc 'Start the application server(s).'
  task :start, :roles => :app do
    restart_passenger
  end

  desc 'Stop the application server(s).'
  task :stop, :roles => :app do
    restart_passenger
  end

  desc 'Restart the application server(s).'
  task :restart, :roles => :app do
    restart_passenger
  end

end


task :add_symlinks, :roles => [:app] do
  run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  run "ln -nfs #{shared_path}/config/server_specific.yml #{release_path}/config/server_specific.yml"

  run "echo '#{app_version}' > #{release_path}/VERSION"

  # relink shared tmp dir (for session and cache data)
  run "rm -rf #{release_path}/tmp"  # technically shouldn't be in git
  run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"
  install_gems_by_bundler
end

task :initial_setup do
  # make shared config dir to hold these config files
  run "umask 02 && mkdir -p #{shared_path}/config"

  # make a shared tmp dir for sessions
  run "umask 02 && mkdir -p #{shared_path}/tmp"
  run "umask 02 && mkdir -p #{shared_path}/tmp/cache"
  run "umask 02 && mkdir -p #{shared_path}/tmp/sessions"
  run "umask 02 && mkdir -p #{shared_path}/tmp/sockets"
  run "umask 02 && mkdir -p #{shared_path}/tmp/pids"

  run "touch #{shared_path}/config/database.yml"
  puts "\n  *** MAKE SURE THAT shared/config/database.yml IS CONFIGURED ON THE REMOTE SERVER."
  puts "\n  *** MAKE SURE THAT shared/config/application.yml IS CONFIGURED ON THE REMOTE SERVER."
end

task :post_update_code, :role => :app do
    case server_type
    when 'stage'
      run "rm #{release_path}/config/env_configs/production.yml && cp #{release_path}/config/env_configs/production-#{server_type}.yml #{release_path}/config/env_configs/production.yml"
      run "rm #{release_path}/config/environments/production.rb && cp #{release_path}/config/environments/production-#{server_type}.rb #{release_path}/config/environments/production.rb"
    end
    install_gems_by_bundler
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end
