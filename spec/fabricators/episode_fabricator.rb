Fabricator(:episode) do
  title { Faker::Hipster.word }
  summary { Faker::Hipster.paragraphs(1, true)}
  description { Faker::Hipster.paragraphs(8, true)}
  published_at { 1.hour.ago }
  channel
  audio do |episode|
    Fabricate.build(:audio, episode: episode)
  end
end

Fabricator(:episode_with_analysed_audio, from: :episode) do
  audio do |episode|
    Fabricate.build(:audio_analysed, episode: episode)
  end
end

Fabricator(:episode_with_failed_audio, from: :episode) do
  audio do |episode|
    Fabricate.build(:audio_failed, episode: episode)
  end
end

Fabricator(:episode_with_failed_audio_3_errors, from: :episode) do
  audio do |episode|
    Fabricate.build(:audio_failed, episode: episode, error_count: 3)
  end
end

Fabricator(:episode_with_invalid_audio, from: :episode) do
  audio do |episode|
    Fabricate.build(:audio_invalid, episode: episode)
  end
end
