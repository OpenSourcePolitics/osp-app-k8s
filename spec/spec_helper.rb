# frozen_string_literal: true

require "decidim/dev"

Decidim::Dev.dummy_app_path = File.expand_path(Rails.root.to_s)

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  config.before(:each) do
    I18n.available_locales = %i(en ca es)
    I18n.default_locale = :en
    I18n.locale = :en
    Decidim.available_locales = %i(en ca es)
    Decidim.default_locale = :en
  end
end
