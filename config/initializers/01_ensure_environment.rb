# frozen_string_literal: true

if Rails.env.production?
  %w(
    DATABASE_HOST
    DATABASE_NAME
    DATABASE_PASSWORD
    DATABASE_PORT
    DATABASE_USERNAME
    MAPS_API_KEY
    REDIS_URL
    SCALEWAY_BUCKET_NAME
    SCALEWAY_ID
    SCALEWAY_TOKEN
    SECRET_KEY_BASE
    SENTRY_DSN
    SMTP_ADDRESS
    SMTP_DOMAIN
    SMTP_PASSWORD
    RAILS_ENV
    RAILS_LOG_TO_STDOUT
    RAILS_SERVE_STATIC_FILES
    APP_NAME
  ).each do |env_var|
    next unless !ENV.has_key?(env_var) || ENV[env_var].blank?

    raise "Missing environment variable: #{env_var}"
  end
end
