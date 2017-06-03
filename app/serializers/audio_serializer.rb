class AudioSerializer < ActiveModel::Serializer
  attributes :url,
             :size,
             :duration,
             :codec,
             :bitrate,
             :sample_rate,
             :status,
             :analysed_at,
             :error_message,
             :error_count

  def status
    object.status.to_s
  end

  def analysed_at
    object.analysed_at&.to_formatted_s
  end
end
