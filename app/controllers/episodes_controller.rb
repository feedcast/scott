class EpisodesController < ApplicationController
  def show
    channel = Channel.find(params[:channel])

    @episode = channel.episodes.find(params[:episode])
  end
end
