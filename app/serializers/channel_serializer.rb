class ChannelSerializer < ActiveModel::Serializer
  attributes :uuid,
             :slug,
             :title,
             :description,
             :feed_url,
             :image_url,
             :listed,
             :synchronization_status,
             :synchronization_status_message

  has_many :categories

  def synchronization_status
    object.synchronization_status.to_s
  end

  def image_url
    object.proxy_image_url
  end
end
