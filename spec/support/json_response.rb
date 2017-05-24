module JsonResponseHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |c|
  c.include JsonResponseHelper
end
