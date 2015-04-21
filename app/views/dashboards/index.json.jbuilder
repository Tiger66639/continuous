json.array!(@dashboards) do |dashboard|
  json.extract! dashboard, :id, :name
  json.url dashboard_url(dashboard, format: :json)
end
