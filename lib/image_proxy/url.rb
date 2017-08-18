require "cgi"

module ImageProxy
  class URL
    HOST = ENV.fetch("FEEDCAST_IMAGE_PROXY_HOST", "images.feedcast.cc")

    attr_accessor :image_url, :height, :width

    def initialize(original_url, height: 300, width: 300)
      @image_url, @height, @width = escape(original_url), height, width
    end

    def to_s
      "https://#{HOST}/#{image_url}/#{height}/#{width}"
    end

    private

    def escape(url)
      CGI.escape(url)
    end
  end
end
