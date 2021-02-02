# frozen_string_literal: true

require "rake"

class PreloadOpenDataJob < ApplicationJob
  queue_as :scheduled

  def perform
    Rake::Task["decidim:open_data:export"].invoke
  end
end
