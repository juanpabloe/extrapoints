source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem "bcrypt-ruby", :require => "bcrypt"
gem 'savon'
gem 'cancan'

gem 'kaminari'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

group :test, :development do
  gem 'sqlite3'
  gem 'turn', :require => false
  gem 'nifty-generators'
  gem 'factory_girl_rails'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'factory_girl_rails'
end

group :production do
  gem 'pg'
  gem 'thin'
  gem 'therubyracer'
end
