source :rubygems

gem 'rails', '3.2.3'
gem 'jquery-rails'

gem 'dynamic_form'
gem 'will_paginate', '~> 3.0'
gem 'rmagick'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'pow-client'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'growl'
end

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
end