technology = Category.create!(title: "Technology", icon: "mobile")
news = Category.create(title: "News", icon: "newspaper-o")
development = Category.create(title: "News", icon: "code")

Channel.create!(
  [
    {
      title: "Hipsters Ponto Tech",
      feed_url: "http://hipsters.tech/feed/podcast/",
      categories: [development, technology]
    },
    {
      title: "NerdCast",
      feed_url: "http://jovemnerd.com.br/categoria/nerdcast/feed/",
      categories: [technology, news]
    },
    {
      title: "Não Ouvo",
      feed_url: "http://feeds.feedburner.com/naoouvo?format=xml"
    },
    {
      title: "Ruby on Rails Podcast",
      feed_url: "http://feeds.5by5.tv/rubyonrails",
      categories: [development, technology]
    },
    {
      title: "Matando Robôs Gigantes",
      feed_url: "http://feed.matandorobosgigantes.com"
    },
  ]
)
