module FlashcardsHelper
  def flashcard_index_from(collection, flashcard)
    "#{collection.index(flashcard) + 1} / #{collection.size}"
  end
end
