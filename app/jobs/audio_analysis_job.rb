class AudioAnalysisJob < ApplicationJob
  queue_as :analysis

  def perform(uuid)
    AudioServices::Analyse.new.call(audio(uuid))
  end

  private

  def audio(uuid)
    Episode.find_by(uuid: uuid).audio
  end
end
