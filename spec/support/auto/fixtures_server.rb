require "sham_rack"

# Hack to allow ShamRack to work with WebMock, we plan to get rid of one soon!
WebMock.allow_net_connect!

ShamRack.at("feedcast.com").sinatra do
  get "/:file" do
    File.read(File.join("spec", "fixtures", params[:file]))
  end

  get "/redirect/:file" do
    redirect "/#{params[:file]}", 301
  end
end
