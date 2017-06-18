class ApplicationJob < ActiveJob::Base
  include FunctionalOperations::DSL

  queue_as :default
end
