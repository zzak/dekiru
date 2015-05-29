json.array!(@jogs) do |jog|
  json.extract! jog, :id, :n
  json.url jog_url(jog, format: :json)
end
