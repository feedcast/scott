class EpisodeSearchSerializer < ActiveModel::Serializer
  attributes :uuid,
             :path,
             :title,
             :summary,
             :description

  def path
    "/#{object.channel.slug}/#{object.slug}"
  end
end
