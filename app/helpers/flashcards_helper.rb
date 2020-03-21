module FlashcardsHelper
  def exam_flashcard_index(collection, flashcard)
    "#{collection.index(flashcard) + 1} / #{collection.size}"
  end

  def flashcard_index(collection, flashcard)
    # debugger
    "#{collection.index(flashcard) + 1} / #{collection.size}"
  end
end
