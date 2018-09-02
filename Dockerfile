FROM node:4.2.0

WORKDIR /usr/src/moi-front-end

COPY package*.json ./

ENV NODE_ENV=development

RUN npm install grunt -g

RUN npm install

COPY . .

RUN /usr/src/moi-front-end/node_modules/.bin/bower install --allow-root

RUN \
  apt-get update && apt-get install -y --no-install-recommends --no-install-suggests curl bzip2 build-essential libssl-dev libreadline-dev zlib1g-dev && \
  rm -rf /var/lib/apt/lists/* && \
  curl -L https://github.com/sstephenson/ruby-build/archive/v20180329.tar.gz | tar -zxvf - -C /tmp/ && \
  cd /tmp/ruby-build-* && ./install.sh && cd / && \
  ruby-build -v 2.1.4 /usr/local && rm -rfv /tmp/ruby-build-* && \
  gem install bundler --no-rdoc --no-ri

RUN gem install bundler

RUN bundle install

EXPOSE 8100

CMD [ "grunt", "serve" ]
