class EpisodesController < ApplicationController
  def show
    channel = Channel.find(params[:channel])
    @episode = channel.episodes.find_by(uuid: params[:episode])
  end
end
