# 開発用 Dockerfile（最小構成）
FROM ruby:3.3-slim

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    BUNDLE_PATH=/usr/local/bundle

# pg のビルドと Rails 実行に必要なパッケージ
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential libpq-dev libyaml-dev git curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 依存だけ先にインストールしてレイヤキャッシュを効かせる
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
