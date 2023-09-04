FROM ruby:3.2.2
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs cmake pkg-config
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY package.json /myapp/package.json
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install
RUN npm install
COPY . /myapp
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
