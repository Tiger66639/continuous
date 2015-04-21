json.array!(@replicas) do |replica|
  json.extract! replica, :id, :name, :destination
  json.url replica_url(replica, format: :json)
end
