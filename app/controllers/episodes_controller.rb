class EpisodesController < ApplicationController
  def show
    channel = Channel.find(params[:channel])

    @episode = channel.episodes.find(params[:episode])
  end

  def list
    @episodes = Episode.all.order_by(published_at: :desc).limit(12)
  end
end
