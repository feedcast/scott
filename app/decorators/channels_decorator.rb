class ChannelsDecorator < CollectionDecorator
  def page_title
    h.t(:"channel.page_title", page: current_page.to_s)
  end
end
