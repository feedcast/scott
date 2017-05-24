class ChannelSerializer < ActiveModel::Serializer
  attributes :uuid, :slug, :title, :description
end
