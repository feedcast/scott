Fabricator(:category) do
  title { Faker::Hipster.word }
  icon { FontAwesome::ICONS.sample }
end
