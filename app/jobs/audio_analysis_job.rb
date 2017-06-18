class AudioAnalysisJob < ApplicationJob
  queue_as :analysis

  def perform(episode_uuid)
    run(AudioOperations::Analyse, audio: Episode.find_by(uuid: episode_uuid).audio)
  end
end
