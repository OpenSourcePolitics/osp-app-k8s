# frozen_string_literal: true

require "rake"

class CalculateAllMetricsJob < ApplicationJob
  queue_as :scheduled

  def perform
    Rails.application.load_tasks
    Rake::Task["decidim:metrics:all"].invoke
  end
end
