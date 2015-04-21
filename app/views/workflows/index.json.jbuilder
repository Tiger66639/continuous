json.array!(@workflows) do |workflow|
  json.extract! workflow, :id, :name,  :description, :status
  json.url workflow_url(workflow, format: :json)
end
