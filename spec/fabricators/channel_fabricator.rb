Fabricator(:channel) do
  title { Faker::Hipster.words(rand(10), true) }
  feed_url { Faker::Internet.url(path: "/feed") }
end

Fabricator(:channel_with_episodes, from: :channel) do
  episodes(rand: 3) do |_attrs, i|
    Fabricate(:episode, published_at: i.days.ago )
  end
end
