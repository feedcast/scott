class EpisodeSearchSerializer < ActiveModel::Serializer
  attributes :uuid,
             :path,
             :title,
             :image,
             :summary,
             :description

  def path
    "/#{object.channel.slug}/#{object.slug}"
  end

  def image
    object.channel.proxy_image_url
  end
end
