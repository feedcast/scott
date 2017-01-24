module AudioOperations
  class Analyse < FunctionalOperations::Operation
    def arguments
      required :audio, Audio
    end

    def perform
      audio_file = download(@audio.url)
      audio_data = ffmpeg(audio_file)
      audio_wave = wave(audio_file, audio_data.duration)

      @audio.update(size: audio_data.size,
                    duration: audio_data.duration,
                    codec: audio_data.audio_codec,
                    bitrate: audio_data.audio_bitrate,
                    sample_rate: audio_data.audio_sample_rate,
                    wave: audio_wave)

      @audio.analyse!
    rescue StandardError => e
      @audio.fail!(e.message)
    end

    private

    def download(url)
      run(AudioOperations::Download, url: url)
    end

    def ffmpeg(file)
      run(AudioOperations::FFMPEG, file_path: file)
    end

    def wave(file, duration)
      run(AudioOperations::Wave, file_path: file, duration: duration.to_i)
    end
  end
end
