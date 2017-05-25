class Channel
  rails_admin do
    list do
      field :title do
        searchable true
      end

      field :listed do
        searchable true
      end

      field :categories do
        searchable true
      end

      field :synchronization_status do
        searchable false
      end

      field :created_at do
        searchable true
      end

      field :image_url do
        searchable true
      end
    end

    configure :episodes do
      hide
    end

    configure :uuid do
      hide
    end
  end
end
