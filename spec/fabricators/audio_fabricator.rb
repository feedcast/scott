Fabricator(:audio) do
  url { "http://feedcast.com/valid.mp3" }
end

Fabricator(:audio_failed, from: :audio) do
  status { :failed }
end

Fabricator(:audio_invalid, from: :audio) do
  url { "http://feedcast.com/invalid.mp3" }
end

Fabricator(:audio_analysed, from: :audio) do
  url { "http://feedcast.com/valid.mp3" }
  status { :analysed }
  duration { 3002.3 }
end
