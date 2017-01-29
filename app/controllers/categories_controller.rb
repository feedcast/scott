class CategoriesController < ApplicationController
  def list
    @categories = Category.all.decorate
  end

  def show
    @category = Category.find(params[:category])
    @channels = @category.channels.listed.order_by(created_at: :desc).decorate
  end
end
