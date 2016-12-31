class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid

  field :name, type: String
  field :slug, type: String

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  rails_admin do
    configure :uuid do
      hide
    end
  end
end
