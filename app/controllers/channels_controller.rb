class ChannelsController < ApplicationController
  def show
    @channel = Channel.find_by(slug: params[:channel])
  end
end
