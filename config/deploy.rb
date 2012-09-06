require 'bundler/capistrano'

set :application, "goodclinic"
set :domain, "#{application}.osori.cc"

set :repository,  "ssh://osori.cc/home/deployer/repo/#{application}.git"
set :scm, :git
set :branch, 'master'
set :user, 'deployer'
set :user_sudo, false

server 'osori.cc', :web, :app, :db, :primary => true
set :deploy_to, "/var/www/#{domain}"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end