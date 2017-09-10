require "webmock"
include WebMock::API

# WebMock.allow_net_connect!

class MockFileServer < Sinatra::Base
  get "/:file" do
    File.read(File.join("spec", "fixtures", params[:file]))
  end

  get "/redirect/:file" do
    redirect "/#{params[:file]}", 301
  end
end

stub_request(:any, /feedcast/).to_rack(MockFileServer)
