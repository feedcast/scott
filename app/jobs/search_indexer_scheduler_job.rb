class SearchIndexerSchedulerJob < ApplicationJob
  queue_as :index

  def perform
    run(ChannelOperations::IndexAllOutdated)
  end
end
