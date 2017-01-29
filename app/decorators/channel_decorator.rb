class ChannelDecorator < ApplicationDecorator
  decorates_association :categories
  decorates_association :episodes
end
