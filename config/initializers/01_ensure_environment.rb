# frozen_string_literal: true

def required_env_vars
  %w(
    DATABASE_HOST
    DATABASE_NAME
    DATABASE_PASSWORD
    DATABASE_PORT
    DATABASE_USERNAME
    REDIS_URL
    SCALEWAY_BUCKET_NAME
    SCALEWAY_ID
    SCALEWAY_TOKEN
    SECRET_KEY_BASE
    SMTP_ADDRESS
    SMTP_DOMAIN
    SMTP_PASSWORD
    RAILS_ENV
    RAILS_LOG_TO_STDOUT
    RAILS_SERVE_STATIC_FILES
    APP_NAME
  )
end

def optional_env_vars
  %w(SENTRY_DSN)
end

if Rails.env.production? && ENV["DISABLE_ENV_CHECKUP"].blank?
  required_env_vars.each do |env_var|
    next unless !ENV.has_key?(env_var) || ENV[env_var].blank?

    raise "Missing environment variable: #{env_var}"
  end

  optional_env_vars.each do |env_var|
    next unless !ENV.has_key?(env_var) || ENV[env_var].blank?

    Rails.logger.warn "Missing environment variable: #{env_var}"
  end
end
