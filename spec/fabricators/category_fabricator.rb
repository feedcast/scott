Fabricator(:category) do
  title { Faker::Hipster.word }
  icon { FontAwesome::ICONS.sample }
end

Fabricator(:category_with_channels, from: :category) do
  channels { [Fabricate(:channel_without_categories), Fabricate(:channel_without_categories)] }
end
