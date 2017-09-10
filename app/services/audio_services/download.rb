require "rest-client"
require "tempfile"

module AudioServices
  class DownloadError < StandardError; end
  class Download
    def call(url)
      content = get(url)

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
      response = RestClient::Request.execute(method: :get,
                                             url: uri,
                                             raw_response: true)
      response.to_s
    end
  end
end
