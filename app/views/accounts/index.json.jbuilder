json.array!(@accounts) do |account|
  json.extract! account, :id, :uuid, :name
  json.url account_url(account, format: :json)
end
