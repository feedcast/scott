class ChannelsController < ApplicationController
  def show
    @channel = Channel.find(params[:channel])
    ab_finished(:channel_sorting_strategy)
  end

  def list
    @channels = Channel.all.order_by(created_at: :desc).limit(12)
  end

  def search
    @channels = Channel.search(search_term).limit(30)

    render :list
  end

  private

  def search_term
    params[:term]
  end
end
