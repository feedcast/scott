module ApplicationHelper
  include SanitizeHelper

  def application_title
    default_title = t(:feedcast)

    if content_for?(:title)
      "#{content_for(:title)} | #{default_title}"
    else
      default_title
    end
  end

  def image_url_for(channel)
    return placeholdit(channel.title) if channel.image_url.nil? || channel.image_url.empty?

    channel.image_url
  end

  def placeholdit(text)
    "http://placehold.it/350x150?text=#{URI.encode(text.truncate(15))}"
  end

  def format_duration(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
