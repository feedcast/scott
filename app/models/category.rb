class Category
  include Mongoid::Document
  include Mongoid::Slug

  field :title, type: String
  field :icon, type: String

  slug :title

  validates :title, presence: true
  validates :icon, presence: true, inclusion: { in: FontAwesome::ICONS }

  has_and_belongs_to_many :channels

  def icon_html
    FontAwesome::Icon.new(icon).to_html
  end

  rails_admin do
    list do
      field :title do
        searchable true
      end
    end
  end
end
