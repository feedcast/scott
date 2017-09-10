class EpisodeSearchSerializer < ActiveModel::Serializer
  attributes :uuid,
             :path,
             :title

  def path
    "/#{object.channel.slug}/#{object.slug}"
  end
end
