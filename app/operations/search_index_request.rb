class SearchIndexRequest
  def initialize(episode)
    @episode = episode
  end

  def perform
    uri = URI.parse("#{ENV.fetch('FEEDCAST_SEARCH')}/index/episode")
    http = Net::HTTP.new(uri.host, uri.port)
    body = "{
      'uuid': '#{@episode.uuid}',
      'title': '#{@episode.title}'
    }".to_json
    http.send_request("PUT", body)
  end
end
