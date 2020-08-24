source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

gem 'active_storage_validations', '0.8.9'
gem 'bcrypt',                     '3.1.13'
gem 'bootsnap',                   '1.4.6', require: false
gem 'bootstrap-sass',             '3.4.1'
gem 'bootstrap-will_paginate',    '1.0.0'
gem 'cocoon'
gem 'config'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'faker', '2.11.0'
gem 'image_processing', '1.9.3'
gem 'jbuilder', '2.10.0'
gem 'mini_magick', '4.9.5'
gem 'puma', '4.3.5'
gem 'ransack'
gem 'sass-rails', '6.0.0'
gem 'select2-rails'
gem 'turbolinks', '5.2.1'
gem 'webpacker', '4.2.2'
gem 'will_paginate', '3.3.0'

group :development, :test do
  gem 'byebug',  '11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'sqlite3', '1.4.2'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen',                '3.2.1'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console',           '4.0.2'
end

group :test do
  gem 'capybara',                 '3.32.2'
  gem 'guard',                    '2.16.2'
  gem 'guard-minitest',           '2.4.6'
  gem 'minitest',                 '5.11.3'
  gem 'minitest-reporters',       '1.3.8'
  gem 'rails-controller-testing', '1.0.4'
  gem 'selenium-webdriver',       '3.142.7'
  gem 'webdrivers',               '4.3.0'
end

group :production do
  gem 'aws-sdk-s3', '1.46.0', require: false
  gem 'pg',         '1.2.3'
end
