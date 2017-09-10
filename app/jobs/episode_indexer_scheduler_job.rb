class EpisodeIndexerSchedulerJob < ApplicationJob
  queue_as :indexing

  def perform
    EpisodeServices::IndexOutdated.new.call
  end
end
