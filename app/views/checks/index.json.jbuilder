json.array!(@checks) do |check|
  json.extract! check, :id, :name, :checktype, :information
  json.url check_url(check, format: :json)
end
