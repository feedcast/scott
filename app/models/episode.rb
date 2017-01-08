class Episode
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid
  include Mongoid::Slug

  field :title, type: String
  field :summary, type: String
  field :description, type: String
  field :url, type: String
  field :published_at, type: DateTime

  slug :title, scoped: :channel

  validates :title, presence: true
  validates :url, presence: true
  validates :published_at, presence: true

  belongs_to :channel

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
