class Audio
  include Mongoid::Document

  ANALYSED = :analysed
  FAILED = :failed
  NEW = :new
  STATUS = [ NEW, ANALYSED, FAILED ]

  MAX_ERROR_COUNT = 3

  field :url, type: String
  field :size, type: Integer, default: 0
  field :duration, type: Float, default: 0.0
  field :codec, type: String, default: ""
  field :bitrate, type: Integer, default: 0
  field :sample_rate, type: Integer, default: 0

  field :status, type: Symbol, default: :new
  field :analysed_at, type: DateTime
  field :error_message, type: String
  field :error_count, type: Integer, default: 0

  validates :url, presence: true
  validates :status, inclusion: { in: STATUS }

  embedded_in :episode

  def analysed?
    self.status == :analysed
  end

  def failed?
    self.status == :failed
  end

  def analyse!
    self.status = :analysed
    self.analysed_at = Time.now
    self.error_message = ""
    self.error_count = 0

    save!
  end

  def fail!(message)
    self.status = :failed
    self.analysed_at = Time.now
    self.error_message = message
    self.error_count += 1

    save!
  end
end
