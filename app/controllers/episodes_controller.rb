class EpisodesController < ApplicationController
  def show
    channel = Channel.find(params[:channel])

    @episode = Episode.find_by("_slugs" => params[:episode], "channel_id" => channel.id).decorate
  end

  def list
    @episodes = Episode.order_by(published_at: :desc).page(page).per(24).decorate
  end

  private

  def page
    params[:page]
  end
end
