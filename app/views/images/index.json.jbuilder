json.array!(@images) do |image|
  json.extract! image, :id, :name, :uuid, :imagetype, :location
  json.url image_url(image, format: :json)
end
