require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'

load 'deploy/assets'

set :rails_env, 'production'
set :application, 'app'
set :domain, 'USER@EXAMPLE.RU'
set :deploy_to, "/home/deployer/#{application}" #don't forget change path in unicron.rb
set :use_sudo, false

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_ruby_string, "ruby-1.9.3@#{application}"
set :rvm_type, :user

set :scm, :git
set :repository, 'git@github.com:XXX.git'
set :deploy_via, :remote_cache

set :keep_releases, 3

role :web, domain
role :app, domain
role :db,  domain, :primary => true

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end

namespace :migration do
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && bundle exec rake db:migrate RAILS_ENV='#{rails_env}'"
  end
  #task :dbconfig do
  #  run "ln -s #{deploy_to}/database.yml #{release_path}/config/database.yml"
  #end
end

before 'deploy:setup',      'rvm:install_rvm',      'rvm:install_ruby'

after  'deploy:update',     'deploy:cleanup'
after  'migration:reload',  'deploy:restart'
#after  'deploy:finalize_update',    'migration:dbconfig'

require './config/boot'