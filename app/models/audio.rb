class Audio
  include Mongoid::Document

  field :url, type: String

  validates :url, presence: true

  embedded_in :episode
end
