class SearchIndexerSchedulerJob < ApplicationJob
  queue_as :index

  def perform(*args)
    run(ChannelOperations::IndexAllOutdated)
  end
end
