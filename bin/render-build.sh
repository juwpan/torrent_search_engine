set -o errexit

bundle install
yarn install
yarn build:css
yarn build
bundle exec rake db:migrate