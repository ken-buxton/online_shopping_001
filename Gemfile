source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

gem 'rails_serve_static_assets'

# Use sqlite3 as the database for Active Record for development and test
group :development, :test do 
  gem 'sqlite3'
end

# To handle all the administrative heavy lifting
#gem 'activeadmin'
# Until the rails 4 version is officially released. This is all you need
gem 'activeadmin', github: 'gregbell/active_admin', branch: 'master'

# Needed this for Heroku
gem 'thread_safe', '0.3.1'

group :assets do 
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.0'
  
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
  
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# To force load on 5/20/14 for screen scraping stuff.
# gem 'crack'
# gem 'rest-client'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'pg', '0.17.1' 

# Replaced will_paginate with kaminari
gem 'will_paginate', '~> 3.0.5'
#gem 'will_paginate', '~> 3.0.3'

# Use ActiveModel has_secure_password - this was for home made authentication
gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
