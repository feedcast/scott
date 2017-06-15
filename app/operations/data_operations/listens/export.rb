module DataOperations
  module Listens
    class Export < FunctionalOperations::Operation
      REMOTE_PATH = "data-science/episode-listens.csv"

      def perform
        generate_csv_to(tmp_file)
        upload!(tmp_file)
      end

      private

      def generate_csv_to(file)
        run(DataOperations::Listens::GenerateCSV, target_path: file)

        tmp_file
      end

      def tmp_file
        Tempfile.new.path
      end

      def upload!(file)
        run(DataOperations::Upload, local_path: file, remote_path: REMOTE_PATH)
      end
    end
  end
end
