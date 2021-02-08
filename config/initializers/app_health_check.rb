# frozen_string_literal: true

if Rails.env.production?
  HealthCheck.setup do |config|
    # uri prefix (no leading slash)
    config.uri = "app_health_check"

    # Text output upon success
    config.success = "success"

    # Timeout in seconds used when checking smtp server
    config.smtp_timeout = 30.0

    # bucket names to test connectivity - required only if s3 check used, access permissions can be mixed
    # config.buckets = {'bucket_name' => [:R, :W, :D]}

    # You can set what tests are run with the 'full' or 'all' parameter
    # TODO: Implement S3
    config.full_checks = %w(database migrations email cache site)
    # config.full_checks = ['database', 'migrations', 'email', 'cache', 's3']

    # Whitelist requesting IPs
    # Defaults to blank and allows any IP
    config.origin_ip_whitelist = %w(127.0.0.1)

    # http status code used when the ip is not allowed for the request
    config.http_status_for_ip_whitelist_error = 403
  end
end
