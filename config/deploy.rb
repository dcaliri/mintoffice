set :stages, %w(dev production)
set :default_stage, "dev"
require 'capistrano/ext/multistage'

set :application, 'mintoffice'