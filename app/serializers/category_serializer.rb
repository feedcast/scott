class CategorySerializer < ActiveModel::Serializer
  attributes :slug, :title, :icon

  has_many :channels
end
