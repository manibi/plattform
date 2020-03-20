class FlashcardQueue < ApplicationRecord
  belongs_to :flashcard
  belongs_to :article
  belongs_to :user

  # one uniq queue for an user, article
  # once created will remain empty
  # if it is empty fill it on article show and on repeat quiz
  # always go to the next flashcard, if current correct take it out from the queue
  # next should go to the start if current is the last one

  # define a queue - serialized array
  # init
  # add
  # remove
  # next

  def self.all_for(user, article)
    Flashcard.joins(:flashcard_queues).where(flashcard_queues: {user: User.last, article: article})
  end

  def self.next_for(user, article)
    self.all_for(user, article).sample
  end
end
