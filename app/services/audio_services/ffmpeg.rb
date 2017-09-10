require "streamio-ffmpeg"

module AudioServices
  class FFMPEG
    class InvalidAudioFile < StandardError; end

    def call(file_path)
      file = ::FFMPEG::Movie.new(file_path)

      raise InvalidAudioFile, "Invalid Audio File - #{file.metadata[:error][:string]}" unless file.valid?

      file
    end
  end
end
