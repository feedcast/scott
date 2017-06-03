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

  def synchronization_status
    object.synchronization_status.to_s
  end
end
