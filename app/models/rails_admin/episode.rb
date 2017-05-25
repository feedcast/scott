class Episode
  rails_admin do
    list do
      field :title do
        searchable true
      end

      field :channel do
        searchable true
      end

      field :created_at do
        searchable true
      end
    end

    configure :uuid do
      hide
    end
  end
end
