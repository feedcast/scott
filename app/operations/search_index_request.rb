class SearchIndexRequest
  def initialize(indexed)
    @indexed = indexed
    @type = indexed.class.to_s.downcase
  end

  def perform
    uri = URI.parse("#{ENV.fetch('FEEDCAST_SEARCH')}/index/#{@type}")
    http = Net::HTTP.new(uri.host, uri.port)
    body = "{
      'uuid': '#{@indexed.uuid}',
      'title': '#{@indexed.title}'
    }".to_json
    http.send_request('PUT', body)
  end
end
