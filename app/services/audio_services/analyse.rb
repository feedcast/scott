module AudioServices
  class Analyse
    def call(audio)
      audio_file = download(audio.url)
      audio_data = ffmpeg(audio_file)

      audio.update(size: audio_data.size,
                   duration: audio_data.duration,
                   codec: audio_data.audio_codec,
                   bitrate: audio_data.audio_bitrate,
                   sample_rate: audio_data.audio_sample_rate)
      audio.analyse!
    rescue StandardError => e
      audio.fail!(e.message)
    end

    private

    def download(url)
      AudioServices::Download.new.call(url)
    end

    def ffmpeg(file)
      AudioServices::FFMPEG.new.call(file)
    end
  end
end
