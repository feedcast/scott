class SearchIndexerSchedulerJob < ApplicationJob
  queue_as :indexing

  def perform
    run(ChannelOperations::IndexAllOutdated)
  end
end
