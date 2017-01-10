class MoveUrlToAudio < Mongoid::Migration
  def self.up
    Episode.all.each do |episode|
      episode.audio = Audio.new(url: episode.url) unless episode.url.nil?
      episode.save!
    end
  end
end
