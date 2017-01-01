class Episode
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid

  field :title, type: String
  field :description, type: String
  field :url, type: String
  field :published_at, type: DateTime

  validates :title, presence: true
  validates :url, presence: true
  validates :published_at, presence: true

  belongs_to :channel

  rails_admin do
    configure :uuid do
      hide
    end
  end
end
