source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"

gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "redis", "~> 4.0"
# gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sassc-rails"

gem 'mechanize'
gem 'will_paginate', '~> 3.3'

group :development, :test do
  gem "sqlite3", "~> 1.4"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails'
end

group :development do
  gem 'bullet'
  gem "web-console"
  # gem "rack-mini-profiler"
  # gem "spring"
end
