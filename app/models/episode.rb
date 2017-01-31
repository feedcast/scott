class Episode
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid
  include Mongoid::Slug

  field :title, type: String
  field :summary, type: String
  field :description, type: String
  field :published_at, type: DateTime

  slug :title, scoped: :channel

  validates :title, presence: true
  validates :audio, presence: true
  validates :published_at, presence: true, date: { before: Proc.new{ 12.hours.from_now } }

  belongs_to :channel
  embeds_one :audio
  accepts_nested_attributes_for :audio

  index({ published_at: 1, channel_id: 1 }, unique: true)

  scope :not_analysed, -> do
    where(:"audio.status".ne => Audio::ANALYSED)
     .and(:"audio.error_count".lt => Audio::MAX_ERROR_COUNT)
  end

  def next
    recentest = self.channel.episodes
                            .where(:id.ne => self.id,
                                   :published_at.gt => self.published_at)
                            .order_by(published_at: :asc)
                            .first

    return recentest unless recentest.nil?

    Episode.where(:id.ne => self.id).sample
  end

  rails_admin do
    list do
      field :title do
        searchable true
      end

      field :channel do
        searchable true
      end

      field :created_at do
        searchable true
      end
    end

    configure :uuid do
      hide
    end
  end
end
