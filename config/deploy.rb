set :normalize_asset_timestamps, false

# Git repository
set :scm,         :git
set :repository,  'git@github.com:dddaisuke/trello-schedule-dashboard.git'
set :branch,      'master'

# Server setting
ec2 = 'ec2-xxx-xxx-xxx-xxx.us-west-2.compute.amazonaws.com'
role :web, ec2
role :app, ec2
role :db,  ec2, :primary => true

set :application, 'trello-schedule-dashboard'
set :user, 'deployer'
set :use_sudo, false
set :deploy_to, lambda { "/home/#{user}/#{application}" }
set :deploy_via, :copy
set :rails_env, 'production'

# Unicorn用に起動/停止タスクを変更
namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; unicorn -c config/unicorn.rb -E #{rails_env} -D"
  end
  task :restart, :roles => :app do
    if File.exist? "/tmp/unicorn_#{application}.pid"
      run "kill -s USR2 `cat /tmp/unicorn_#{application}.pid`"
    end
  end
  task :stop, :roles => :app do
    run 'kill -s QUIT `cat /tmp/unicorn.pid`'
  end
end
