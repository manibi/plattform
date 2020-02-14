  json.topics do
    json.array!(@topics) do |topic|
      json.name topic.searchable.name
      json.url  topic_path(topic.searchable)
    end
  end

  json.categories do
    json.array!(@categories) do |category|
      json.name category.searchable.title
      json.url  category_path(category.searchable)
    end
  end

  json.articles do
    json.array!(@articles) do |article|
      json.name article.searchable.title
      json.url  article_path(article.searchable)
    end
end
