class EpisodeListen
  include Mongoid::Document

  belongs_to :episode

  field :user_id, type: String
  field :started_at, type: DateTime, default: -> { Time.now.utc }
end
