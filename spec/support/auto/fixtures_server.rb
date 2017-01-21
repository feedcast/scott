require "sham_rack"

ShamRack.at("feedcast.com").sinatra do
  get "/:file" do
    File.read(File.join("spec", "fixtures", params[:file]))
  end

  get "/redirect/:file" do
    redirect "/#{params[:file]}", 301
  end
end
