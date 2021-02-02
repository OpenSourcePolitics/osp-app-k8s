# frozen_string_literal: true

require "rake"

class CalculateAllMetricsJob < ApplicationJob
  queue_as :scheduled

  def perform
    Rake::Task["decidim:metrics:all"].invoke
  end
end
