class ChannelsController < ApplicationController
  def show
    @channel = Channel.find(params[:channel])
    ab_finished(:channel_sorting_strategy)
  end

  def list
    ab_test(:channel_sorting_strategy, "synchronized_at", "created_at", "title") do |strategy|
      field = strategy.to_sym

      @channels = Channel.all.order_by(field => :desc)
    end
  end
end
