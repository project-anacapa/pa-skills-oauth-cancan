json.array!(@exercises) do |exercise|
  json.extract! exercise, :id, :title, :content
  json.url exercise_url(exercise, format: :json)
end
