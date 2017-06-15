Fabricator(:episode_listen) do
  user_id { SecureRandom.uuid }
  episode { Fabricate(:episode) }
  started_at { Time.now }
end
