class EpisodeIndexerJob < ApplicationJob
  queue_as :indexing

  def perform(episode)
    EpisodeServices::Index.new.call(Episode.find_by(uuid: episode))
  end
end
