namespace :episodes do
  desc "Episodes Operations"
  task analyse: :environment do
    include FunctionalOperations::DSL

    run(EpisodeOperations::AnalyseAll)
  end
end
