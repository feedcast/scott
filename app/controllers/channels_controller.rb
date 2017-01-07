class ChannelsController < ApplicationController
  def show
    @channel = Channel.find(params[:channel])
    ab_finished(:channel_sorting_strategy)
  end

  def list
    @channels = Channel.all.order_by(created_at: :desc).limit(12)
  end
end
