json.array!(@cistacks) do |cistack|
  json.extract! cistack, :id, :name, :status, :publicip
  json.url cistack_url(cistack, format: :json)
end
