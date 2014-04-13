json.array!(@states) do |state|
  json.extract! state, :id, :state, :state2
  json.url state_url(state, format: :json)
end
