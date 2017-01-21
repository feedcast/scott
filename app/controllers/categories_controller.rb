class CategoriesController < ApplicationController
  def list
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:category])
    @channels = @category.channels.order_by(created_at: :desc)
  end
end
