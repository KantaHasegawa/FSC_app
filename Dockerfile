#既存のプロジェクトのrubyのバージョンを指定
FROM ruby:2.6.6

#パッケージの取得
RUN rm -rf node_modules/ \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends\
    nodejs  \
    yarn \
    mariadb-client  \
    build-essential  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /FSC_app

COPY Gemfile /FSC_app/Gemfile
COPY Gemfile.lock /FSC_app/Gemfile.lock

RUN gem install bundler
RUN bundle install


#既存railsプロジェクトをコンテナ内にコピー
COPY . FSC_app
