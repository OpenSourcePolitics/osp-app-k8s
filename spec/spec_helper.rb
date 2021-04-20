# frozen_string_literal: true

require "decidim/dev"

Decidim::Dev.dummy_app_path = File.expand_path(Rails.root.to_s)

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  AVAILABLE_LOCALES = [:en, :ca, :es].freeze
  DEFAULT_LOCALE = :en

  config.before do
    # I18n locales configuration
    I18n.available_locales = AVAILABLE_LOCALES
    I18n.default_locale = DEFAULT_LOCALE
    I18n.locale = DEFAULT_LOCALE

    # Decidim locales configuration
    Decidim.available_locales = AVAILABLE_LOCALES
    Decidim.default_locale = DEFAULT_LOCALE
  end
end
