class EpisodeIndexerJob < ApplicationJob
  queue_as :indexing

  def perform(episode)
    run(EpisodeOperations::Index, episode: Episode.find_by(uuid: episode))
  end
end
