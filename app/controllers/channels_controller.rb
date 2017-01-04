class ChannelsController < ApplicationController
  def show
    @channel = Channel.find(params[:channel])
  end
end
