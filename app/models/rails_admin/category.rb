class Category
  rails_admin do
    list do
      field :title do
        searchable true
      end
    end
  end
end
