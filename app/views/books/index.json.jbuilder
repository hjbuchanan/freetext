json.array!(@books) do |book|
  json.extract! book, :id, :author, :title, :publisher
  json.url book_url(book, format: :json)
end
