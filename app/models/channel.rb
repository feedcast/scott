class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid
  include Mongoid::Slug

  FEED_SYNCHRONIZATION_STATUSES = [:new, :success, :failure]

  field :title, type: String
  field :description, type: String
  field :site_url, type: String
  field :feed_url, type: String
  field :image_url, type: String
  field :synchronization_status, type: Symbol, default: :new
  field :synchronization_status_message, type: String
  field :synchronized_at, type: Time, default: 1.year.ago
  field :listed, type: Boolean, default: true

  slug :title

  validates :title, presence: true
  validates :synchronized_at, presence: true
  validates :synchronization_status, presence: true, inclusion: { in: FEED_SYNCHRONIZATION_STATUSES }

  has_and_belongs_to_many :categories
  has_many :episodes, dependent: :destroy
  accepts_nested_attributes_for :episodes

  scope :listed, ->{ where(listed: true) }
  scope :search, ->(term){ where(title: /#{Regexp.escape(term)}/i) }

  def synchronization_success!
    self.synchronization_status = :success
    self.synchronized_at = Time.now
    self.synchronization_status_message = ""

    save!
  end

  def synchronization_failure!(message)
    self.synchronization_status = :failure
    self.synchronized_at = Time.now
    self.synchronization_status_message = message

    save!
  end

  def synchronized?
    synchronization_status == :success
  end

  def failed?
    synchronization_status == :failure
  end

  rails_admin do
    list do
      field :title do
        searchable true
      end

      field :listed do
        searchable true
      end

      field :categories do
        searchable true
      end

      field :synchronization_status do
        searchable false
      end

      field :created_at do
        searchable true
      end

      field :image_url do
        searchable true
      end
    end

    configure :episodes do
      hide
    end

    configure :uuid do
      hide
    end
  end
end
