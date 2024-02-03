FROM ruby:3.2.2-bookworm

WORKDIR /app

COPY ["Gemfile", "/app/Gemfile"]
COPY ["Gemfile.lock", "/app/Gemfile.lock"]

run bundle install

COPY ["github-repos.rb", "/app/github-repos.rb"]

ENTRYPOINT ["ruby", "github-repos.rb"]
