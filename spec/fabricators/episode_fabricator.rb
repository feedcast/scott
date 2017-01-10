Fabricator(:episode) do
  title { Faker::Hipster.word }
  summary { Faker::Hipster.paragraphs(1, true)}
  description { Faker::Hipster.paragraphs(8, true)}
  url { Faker::Internet.url }
  published_at { Faker::Time.between(30.minutes.ago.to_time, Time.now) }
  channel
  audio do |episode|
    Fabricate.build(:audio, episode: episode)
  end
end
