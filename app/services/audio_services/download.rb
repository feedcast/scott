require "net/http"
require "tempfile"

module AudioServices
  class DownloadError < StandardError; end
  class Download
    def call(url)
      content = get(url).body

      file = create_tempfile_with(content)

      file.path
    rescue StandardError => e
      raise DownloadError, e.message
    end

    private

    def create_tempfile_with(content)
      file = Tempfile.new
      file.binmode
      file.write(content)
      file.flush

      file
    end

    def get(uri)
      response = Net::HTTP.get_response(URI.parse(uri))
      response_code = response.code.to_i

      if response_code >= 300 && response_code <= 399
        response = get(response.header["location"])
      end

      response
    end
  end
end
