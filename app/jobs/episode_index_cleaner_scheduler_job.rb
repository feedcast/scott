class EpisodeIndexCleanerSchedulerJob < ApplicationJob
  queue_as :indexing

  def perform
    EpisodeServices::CleanIndex.new.call
  end
end
