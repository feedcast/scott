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
