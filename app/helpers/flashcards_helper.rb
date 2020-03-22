module FlashcardsHelper
  def flashcard_index(collection, flashcard)
    "#{collection.index(flashcard) + 1} / #{collection.size}"
  end
end
