class EpisodeIndexerSchedulerJob < ApplicationJob
  queue_as :indexing

  def perform
    run(EpisodeOperations::IndexAllOutdated)
  end
end
