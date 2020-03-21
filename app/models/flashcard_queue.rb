class FlashcardQueue < ApplicationRecord
  belongs_to :article
  belongs_to :user

  serialize :flashcards_queue, Array

  # crate of find queue when you open the article
  # if the queue is empty add all public flashcards for the article
  # go to first one, dequeue
  # if answered wrong enqueue again
  # until the queue is empty

  # define a queue - serialized array
  # init
  # add
  # remove
  # next

  def self.init_flashcards_queue(user, article)
    new_queue = FlashcardQueue.find_or_create_by(user: user, article: article)
    if new_queue.flashcards_queue.empty?
      new_queue.update(flashcards_queue: article.flashcards.published.order(:id).to_a)
    end

    new_queue
  end

  def enqueue!(flashcard)
    self.update(flashcards_queue: flashcards_queue.push(flashcard))
  end

  def dequeue!
    flashcard = self.flashcards_queue.shift
    self.save
    flashcard
  end

  def front
    self.flashcards_queue.first
  end

  def back
    self.flashcards_queue.last
  end

  def size
    self.flashcards_queue.size
  end

  def any?
    self.flashcards_queue.any?
  end

  def empty?
    self.flashcards_queue.empty?
  end
end
