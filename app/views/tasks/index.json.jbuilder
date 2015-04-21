json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :tasktype, :definition, :description
  json.url task_url(task, format: :json)
end
