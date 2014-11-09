json.array!(@competitions) do |competition|
  json.extract! competition, :id, :name, :description, :at, :active
  json.url competition_url(competition, format: :json)
end
