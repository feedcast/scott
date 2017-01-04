class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid
  include Mongoid::Slug

  FEED_SYNCHRONIZATION_STATUSES = [:new, :success, :failure]

  field :title, type: String
  field :feed_url, type: String
  field :synchronization_status, type: Symbol, default: :new
  field :synchronization_status_message, type: String
  field :synchronized_at, type: Time

  slug :title

  validates :title, presence: true
  validates :synchronization_status, inclusion: { in: FEED_SYNCHRONIZATION_STATUSES }

  has_many :episodes
  accepts_nested_attributes_for :episodes

  rails_admin do
    configure :episodes do
      hide
    end
    configure :uuid do
      hide
    end
  end

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
end
