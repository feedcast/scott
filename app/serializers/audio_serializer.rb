class AudioSerializer < ActiveModel::Serializer
  attributes :url,
             :size,
             :duration,
             :codec,
             :bitrate,
             :sample_rate,
             :analysed_at,
             :error_message,
             :error_count

  def analysed_at
    object.analysed_at&.to_formatted_s
  end
end
