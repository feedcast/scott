class Episode
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid
  include Mongoid::Slug

  field :title, type: String
  field :summary, type: String
  field :description, type: String
  field :published_at, type: DateTime
  field :url, type: String

  slug :title, scoped: :channel

  validates :title, presence: true
  validates :audio, presence: true
  validates :published_at, presence: true

  belongs_to :channel
  embeds_one :audio
  accepts_nested_attributes_for :audio

  index({ published_at: 1, channel_id: 1 }, unique: true)

  rails_admin do
    list do
      field :title do
        searchable true
      end

      field :channel do
        searchable true
      end
    end
    configure :uuid do
      hide
    end
  end
end
