namespace :channels do
  desc "Channels Operations"
  task synchronize: :environment do
    include FunctionalOperations::DSL

    run(ChannelOperations::SynchronizeAll)
  end
end
