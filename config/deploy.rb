require 'bundler/capistrano'

set :application, "ansim.me"
set :domain, "#{application}"

set :repository,  "ssh://git@github.com:peace-code/#{application}.git"
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
  task :clean_uploads do
    run "rm -rf #{shared_path}/uploads"
    run "mkdir -p #{shared_path}/uploads"
  end

  desc "Symlink shared configs and folders on each release."
  task :create_symlink_shared do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
    run "ln -nfs #{shared_path}/config/apikey.yml #{release_path}/config/apikey.yml"
  end
  after 'deploy:create_symlink', 'deploy:create_symlink_shared'

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end