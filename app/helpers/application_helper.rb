module ApplicationHelper
  def image_url_for(channel)
    channel.image_url || "http://placehold.it/350x150?text=#{URI.encode(channel.title.truncate(15))}"
  end
end
