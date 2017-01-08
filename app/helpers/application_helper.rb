module ApplicationHelper
  def image_url_for(channel)
    return placeholdit(channel.title) if channel.image_url.nil? || channel.image_url.empty?

    channel.image_url
  end

  def placeholdit(text)
    "http://placehold.it/350x150?text=#{URI.encode(text.truncate(15))}"
  end
end
