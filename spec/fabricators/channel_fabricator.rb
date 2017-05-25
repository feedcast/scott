Fabricator(:channel) do
  title { Faker::Hipster.word }
  feed_url { Faker::Internet.url(path: "/feed") }
end

Fabricator(:channel_with_an_invalid_feed_url, from: :channel) do
  feed_url { "http://foo.feedcast.com/not_found.xml" }
end

Fabricator(:channel_with_a_valid_feed, from: :channel) do
  feed_url { "http://feedcast.com/valid.xml" }
end

Fabricator(:channel_with_a_valid_feed_and_some_invalid_episodes, from: :channel) do
  feed_url { "http://feedcast.com/valid_with_2_episodes_1_missing_url.xml" }
end

Fabricator(:channel_with_a_valid_feed_and_one_episode_in_the_future, from: :channel) do
  feed_url { "http://feedcast.com/valid_with_5_episodes_1_in_the_future.xml" }
end

Fabricator(:channel_with_an_invalid_feed, from: :channel) do
  feed_url { "http://feedcast.com/invalid.xml" }
end

Fabricator(:channel_with_an_empty_feed, from: :channel) do
  feed_url { "http://feedcast.com/valid_empty.xml" }
end

Fabricator(:channel_with_episodes, from: :channel) do
  episodes(rand: 3) do |_attrs, i|
    Fabricate(:episode, published_at: i.days.ago)
  end
end
