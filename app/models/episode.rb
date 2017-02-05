class Episode
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid
  include Mongoid::Slug

  ADVANCED_PUBLISHING_INTERVAL = 12.hours

  field :title, type: String
  field :summary, type: String
  field :description, type: String
  field :published_at, type: DateTime

  slug :title, scope: :channel

  validates :title, presence: true
  validates :audio, presence: true
  validates :published_at, presence: true, date: { before: Proc.new{ ADVANCED_PUBLISHING_INTERVAL.from_now } }

  belongs_to :channel
  embeds_one :audio
  accepts_nested_attributes_for :audio

  index({ published_at: 1, channel_id: 1 }, unique: true)

  scope :not_analysed, -> do
    where(:"audio.status".ne => Audio::ANALYSED)
     .and(:"audio.error_count".lt => Audio::MAX_ERROR_COUNT)
  end

  def self.find_for(channel, episode)
    Episode.find_by(_slugs: episode, channel_id: Channel.find(channel).id)
  end

  def next
    return @next if @next.present?

    @next = Episode.where(:id.ne => self.id,
                          :published_at.gt => self.published_at,
                          :channel_id => channel.id)
                    .order_by(published_at: :asc)
                    .first

    @next = Episode.where(:id.ne => self.id).sample if @next.nil?

    @next
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
