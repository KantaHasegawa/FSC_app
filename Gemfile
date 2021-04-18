# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 6.1.3.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

gem 'active_storage_validations', '0.8.9'
gem 'bcrypt',                     '3.1.13'
gem 'bootsnap',                   '1.4.6'
gem 'bootstrap-will_paginate',    '1.0.0'
gem 'carrierwave'
gem 'config'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'faker', '2.11.0'
gem 'image_processing', '1.9.3'
gem 'jbuilder', '2.10.0'
gem 'kaminari'
gem 'mini_magick'
gem 'puma', '4.3.5'
gem 'rails-i18n'
gem 'ransack'
gem 'react-rails', '2.5.0'
gem 'sass-rails', '6.0.0'
gem 'select2-rails'
gem 'webpacker', '4.2.2'
gem 'fog-google'
gem 'google-api-client'

group :development, :test do
  gem 'byebug', '11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'debase', '0.2.4.1'
  gem 'mysql2'
  gem 'ruby-debug-ide', '0.7.2'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'htmlbeautifier'
  gem 'listen', '3.2.1'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console', '4.0.2'
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
  gem 'pg', '1.1.4'
  gem 'rails_12factor', group: :production
end
