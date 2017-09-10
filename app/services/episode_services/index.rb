require "rest-client"

module EpisodeServices
  class Index
    def call(episode)
      trigger_request(episode)

      episode.indexed_at = Time.zone.now
      episode.save!
    end

    private

    def trigger_request(episode)
      RestClient.put(index_uri, serialize(episode), { content_type: :json })
    end

    def serialize(episode)
      ::EpisodeSearchSerializer.new(episode).to_json
    end

    def index_uri
      "#{scully_base_url}/index/episode"
    end

    def scully_base_url
      ENV.fetch("SCULLY_URI")
    end
  end
end
