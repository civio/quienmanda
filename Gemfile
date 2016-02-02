ruby '2.0.0'

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Use Postgres as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use SASS version of Bootstrap 3
gem 'bootstrap-sass', '~> 3.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible. Read more: https://github.com/cyu/rack-cors
gem 'rack-cors', :require => 'rack/cors'

# Serve assets in Heroku and handle logging
gem 'rails_12factor', group: :production

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]


# QuienManda app
gem 'devise'
gem 'cancan'
gem 'figaro'
gem 'stringex'
gem 'kaminari'
gem 'pg_search'
gem 'acts-as-taggable-on'
gem 'shortcodes'
gem 'font-awesome-rails', "~> 3.2.1.2"  # Force version change after CDN cache issues
gem 'unicode_utils'
gem 'rails-i18n', '~> 4.0.0.pre'
gem 'nokogiri'
gem 'acts_as_votable', '~> 0.10.0'

# Users login
gem 'omniauth'
gem 'omniauth-twitter'

# Admin interface
gem 'rails_admin'
gem 'rails_admin_toggleable'
gem 'rails_admin_tag_list'
gem 'ckeditor_rails'
gem 'paper_trail', '~> 4.0.0.beta'
gem 'charlock_holmes_bundle_icu'
gem 'fuzzy_match'

# Picture upload and handling
gem 'mini_magick'
gem 'carrierwave'
gem 'fog'

# Testing
group :development, :test do
  gem 'pry-rails', :group => :development
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'coveralls', require: false
end

# Performance and profiling
gem 'actionpack-action_caching'
gem 'newrelic_rpm'
gem 'memcachier'
gem 'rack-cache'
gem 'dalli'
gem 'kgio'
group :profile do
  gem 'ruby-prof'
end

# Fix cross-domain fonts when using Firefox and a CDN
# See https://discussion.heroku.com/t/fontawesome-doesnt-load-on-firefox-because-of-cors-configuration-issue/35/10
gem 'font_assets'