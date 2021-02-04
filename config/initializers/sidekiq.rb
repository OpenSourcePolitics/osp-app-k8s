# frozen_string_literal: true

require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = {
      url: ENV["REDIS_URL"],
      namespace: "#{ENV["APP_NAME"]}-sidekiq"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
      url: ENV["REDIS_URL"],
      namespace: "#{ENV["APP_NAME"]}-sidekiq"
  }
end

Redis.exists_returns_integer = true
