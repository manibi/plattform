json.topics do
  json.array!(@topics) do |topic|
    if topic.searchable.profession == current_user.profession
      json.name topic.searchable.name
      json.url  topic_path(topic.searchable)
    end
  end
end

json.categories do
  json.array!(@categories) do |category|
    if category.searchable.topic.profession == current_user.profession
      json.name category.searchable.title
      json.url  category_path(category.searchable)
    end
  end
end

json.articles do
  json.array!(@articles) do |article|
    if article.searchable.category.topic.profession == current_user.profession
      json.name article.searchable.title
      json.url  article_path(article.searchable)
    end
  end
end
