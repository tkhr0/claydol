FROM ruby:2.4
WORKDIR /myapp

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install

#CMD ["rackup", "-o", "0.0.0.0"]
CMD ["irb"]
