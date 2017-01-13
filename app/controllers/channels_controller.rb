class ChannelsController < ApplicationController
  def show
    @channel = Channel.find(params[:channel])
    @episodes = @channel.episodes.order_by(published_at: :desc).page(page).per(5)

    ab_finished(:channel_sorting_strategy)
  end

  def list
    @channels = Channel.order_by(created_at: :desc).page(page).per(24)
  end

  def search
    ab_finished(:ab_search_placeholder)

    @channels = Channel.search(search_term).limit(24).page(page)

    render :list
  end

  private

  def search_term
    params[:term]
  end

  def page
    params[:page]
  end
end
