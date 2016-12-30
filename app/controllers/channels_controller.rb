class ChannelsController < ApplicationController
  def show
    @channel = Channel.find_by(slug: params[:slug])
  end
end
