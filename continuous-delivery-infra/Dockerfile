FROM rtyler/presentation-base:latest
MAINTAINER tyler@linux.com


# g++ needed to build the stupid `unf` gem, ruby-io-console for bundler to
# cooperate and ruby-nokogiri since we can't build straight from bundler
RUN apk update && apk add --no-cache bash ruby ruby-dev g++ ruby-nokogiri ruby-io-console vim
# Grab a bunch of ruby tools for demonstration purposes.
# syck gem to make Puppet work properly on Ruby 2.2.x
RUN gem install -N rspec-puppet puppet-lint puppet bundler io-console syck

RUN git clone --depth=1 https://github.com/jenkins-infra/jenkins-infra.git

WORKDIR /jenkins-infra
# remove Gemfile.lock so we aren't bound so tightly to Ruby gem versions (like
# Nokogiri) which don't build properly under Alpine
RUN rm -f Gemfile.lock
# Add the version of Nokogiri installed from our packages to the Gemfile so we
# don't have to fight with it to bundle install, same with `syck`
RUN echo "gem 'nokogiri', '1.6.6.2'" >> Gemfile && echo "gem 'syck'" >> Gemfile && bundle install --without=development
# invoke all Ruby type things with RUBYOPT="-rsyck" to ensure the syck gem gets
# loaded properly for letting bundler sub-invoke Rubies for executing puppet,
# etc
ENV RUBYOPT="-rsyck"
# Pre-cache all of our puppet modules just to make demonstration faster
RUN bundle exec rake spec_prep


WORKDIR /
COPY content /content
CMD /bin/sh -c "/usr/local/bin/mdp -fi /content/preso.md"
