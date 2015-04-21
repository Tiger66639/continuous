json.array!(@ciworkers) do |ciworker|
  json.extract! ciworker, :id, :name, :image, :flavor
  json.url ciworker_url(ciworker, format: :json)
end
