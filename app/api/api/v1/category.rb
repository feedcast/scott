class API::V1::Category < Grape::API
  include Grape::Rails::Cache

  namespace :categories do
    paginate per_page: 10
    get do
      page, per_page = params[:page], params[:per_page]

      cache(key: "api:categories:list:#{page}:#{per_page}", expires_in: 1.hour) do
        categories = paginate(::Category.all)

        { categories: ::CategoriesSerializer.new(categories).as_json }
      end
    end

    route_param :slug do
      get do
        slug = params[:slug]

        cache(key: "api:categories:#{slug}", expires_in: 1.hour) do
          category = ::Category.find(slug)

          CategorySerializer.new(category)
        end
      end
    end
  end
end
