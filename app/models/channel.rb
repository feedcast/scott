class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Uuid

  field :name, type: String
  field :slug, type: String
end
