json.array!(@deploys) do |deploy|
  json.extract! deploy, :id, :uuid, :status
  json.url deploy_url(deploy, format: :json)
end
