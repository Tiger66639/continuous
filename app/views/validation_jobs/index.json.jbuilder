json.array!(@validation_jobs) do |validation_job|
  json.extract! validation_job, :id, :name, :description, :definition
  json.url validation_job_url(validation_job, format: :json)
end
