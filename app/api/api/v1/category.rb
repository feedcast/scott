class API::V1::Category < Grape::API
  namespace :categories do
    paginate per_page: 10
    get do
      categories = ::Category.all

      { categories: ::CategoriesSerializer.new(categories).as_json }
    end

    route_param :slug do
      get do
        category = ::Category.find(params[:slug])

        category
      end
    end
  end
end
