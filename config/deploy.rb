set :user, 'wangsy'
set :domain, "o.mintech.kr"
set :application, 'mintoffice'
set :deploy_to, "/home/#{user}/www/#{application}"

set :rvm_ruby_string, 'ruby-1.9.2-p290'
set :rvm_type, :user
require "rvm/capistrano"

require "bundler/capistrano"

set :repository,  "git@mintech.kr:#{application}.git"
set :scm, :git
set :branch, 'master'
set :scm_verbose, true

set :use_sudo, false
set :rails_env, :development

set :port, 3022
ssh_options[:forward_agent] = true

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :unicorn_env, :development
require "capistrano-unicorn"

namespace :deploy do
  task :create_socket_directory, :roles => :app do 
    run "mkdir -p #{release_path}/tmp/sockets"
    run "ln -sf #{deploy_to}/shared/files #{release_path}/"
  end
end

namespace :unicorn do
  task :reload, :roles => :app do
    stop
    start
  end
end

after 'deploy:create_symlink', 'deploy:create_socket_directory'
#after 'unicorn:reload', 'deploy:restart'