module DataOperations
  module Listens
    class GenerateCSV < FunctionalOperations::Operation
      def arguments
        required :target_path, String
      end

      def perform
        write(raw_csv, @target_path)
      end

      private

      def write(content, to)
        File.write(to, content)
      end

      def raw_csv
        CSV.generate do |csv|
          csv << header
          fetch.each do |listen|
            csv << aggregate(listen)
          end
        end
      end

      def fetch
        EpisodeListen.all.includes(episode: :channel)
      end

      def header
        [
          "user_id",
          "episode_id",
          "channel_id",
          "started_at",
        ]
      end

      def aggregate(listen)
        [
          listen.user_id,
          listen.episode.uuid,
          listen.episode.channel.uuid,
          listen.started_at,
        ]
      end
    end
  end
end
