namespace :with do
  desc "Tasks definitions"

  task english: :environment do
    Rails.application.config.i18n.default_locale = :en
  end

  task logger: :environment do
    if defined?(Rails)
      Rails.logger = if defined?(ActiveSupport::TaggedLogging)
                       ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
                     else
                       Logger.new(STDOUT)
                     end
      Rails.logger.level = Logger::DEBUG
      Rollbar.preconfigure do |config|
        config.logger = Rails.logger
      end
      Rails.logger
    end
  end
end
