FROM ruby:3.1-slim

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  git \
  bash \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock *.gemspec ./
COPY lib/btc_wallet/version.rb ./lib/btc_wallet/version.rb
COPY vendor/bundle ./vendor/bundle

RUN bundle install

COPY . .

RUN bundle exec thor btc:create

CMD ["bundle", "exec", "thor", "btc:balance"]
