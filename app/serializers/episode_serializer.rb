class EpisodeSerializer < ActiveModel::Serializer
  attributes :uuid, :slug, :title, :summary, :description, :published_at

  def published_at
    object.published_at.to_formatted_s
  end
end
