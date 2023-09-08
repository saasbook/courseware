FROM ruby:2.7.7-bullseye

WORKDIR /app

COPY ["Gemfile", "/app/Gemfile"]
COPY ["Gemfile.lock", "/app/Gemfile.lock"]

run bundle install

COPY ["heroku-apps.rb", "/app/heroku-apps.rb"]

ENTRYPOINT ["ruby", "heroku-apps.rb"]
