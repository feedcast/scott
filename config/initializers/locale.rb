Rails.application.config.i18n.default_locale = :"pt-BR" unless Rails.env.test?
Rails.application.config.i18n.fallbacks = { "pt-BR" => "en" }
