set -o errexit

bundle install
yarn install
bundle exec rake assests:precompile
bundle exec rake assests:clean
bundle exec rake db:migrate