set :port, 22
set :user, 'ubuntu'
set :deploy_via, :remote_cache
set :use_sudo, false
set :branch, 'develop' 

server '52.36.35.170', 
  roles: [:web, :app, :db],
  port: fetch(:port),
  user: fetch(:user),
  primary: true

set :deploy_to, "/home/ubuntu/#{fetch(:application)}"

set :ssh_options, {
  forward_agent: true,
  keys: '~/.ssh/rmit-project.pem',
  auth_methods: %w(publickey),
  user: 'ubuntu',
}

set :rails_env, :production
set :conditionally_migrate, true
