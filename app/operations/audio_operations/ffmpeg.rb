require "streamio-ffmpeg"

module AudioOperations
  class FFMPEG < FunctionalOperations::Operation
    class InvalidAudioFile < StandardError; end

    def arguments
      required :file_path, String
    end

    def perform
      file = ::FFMPEG::Movie.new(@file_path)

      raise InvalidAudioFile, "Invalid Audio File - #{file.metadata[:error][:string]}" unless file.valid?

      file
    end
  end
end
