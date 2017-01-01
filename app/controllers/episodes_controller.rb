class EpisodesController < ApplicationController
  def show
    channel = Channel.find_by(slug: params[:channel])
    @episode = channel.episodes.find_by(uuid: params[:episode])
  end
end
