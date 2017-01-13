class EpisodesController < ApplicationController
  def show
    channel = Channel.find(params[:channel])

    @episode = channel.episodes.find(params[:episode])
  end

  def list
    @episodes = Episode.order_by(published_at: :desc).page(page).per(24)
  end

  private

  def page
    params[:page]
  end
end
