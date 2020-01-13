puts "Cleaning DB..."
Chapter.destroy_all
UserArticle.destroy_all
FlashcardAnswer.destroy_all
Answer.destroy_all
UserFlashcard.destroy_all
Flashcard.destroy_all
Article.destroy_all
Topic.destroy_all
User.destroy_all
Profession.destroy_all

puts "Adding professions..."
Profession.create!([
  {
    name: 'Developer'
  },
  {
    name: 'Fighter'
  }
])

developer_profession = Profession.first
fighter_profession   = Profession.second

puts "Creating users..."
developer_profession.users.create!({
    username: "login-string",
    password: "password"
})

fighter_profession.users.create!({
  username: "login-string2",
  password: "password"
})

puts "Creating topics..."
developer_profession.topics.create!({
  name: "Back End Development"
})

fighter_profession.topics.create!({
  name: "BJJ"
})

# profession.topics.create!({
#   name: "Front End Development"
# })

back_end_dev_topic = developer_profession.topics.first
bjj_topic          = fighter_profession.topics.first

puts "Creating articles..."
back_end_dev_topic.articles.create!([
  {
  title: "Ruby on Rails",
  description: "Ruby on Rails, sometimes known as 'RoR or just 'Rails, is an open source framework for Web development in Ruby, an object-oriented programming (OOP) language similar to Perl and Python"
  }
])

bjj_topic.articles.create!([
  {
  title: "Closed guard",
  description: "Basics"
  }
])

# 5.times do |n|
#   profession.topics.second.articles.create!({
#     title: Faker::ProgrammingLanguage.name,
#     description: Faker::Lorem.sentence(word_count: 3)
#   })
# end

rails_article = back_end_dev_topic.articles.first
bjj_article = bjj_topic.articles.first

puts "Creating chapters"
rails_article.chapters.create!([
  {
  title: "Active Record",
  content: "In software engineering, the active record pattern is an architectural pattern found in software that stores in-memory object data in relational databases."
  },
  {
    title: "Action View",
    content: "Action View templates are written using embedded Ruby in tags mingled with HTML. To avoid cluttering the templates with boilerplate code, a number of helper classes provide common behavior for forms, dates, and strings. It's also easy to add new helpers to your application as it evolves."
  }
])

puts "Creating answers..."
10.times do |n|
  Answer.create!({
    content: Faker::Quote.most_interesting_man_in_the_world
  })
end

puts "Creating flashcards..."
# New multiple choice flahscard for first article
flashcard1 = rails_article.flashcards.create!({
  content: "Question 1?",
  flashcard_type: "multiple choice",
})

flashcard2 = rails_article.flashcards.create!({
  content: "Question 2?",
  flashcard_type: "multiple choice",
})

flashcard3 = rails_article.flashcards.create!({
  content: "Question 3?",
  flashcard_type: "multiple choice",
})

flashcard4 = rails_article.flashcards.create!({
  content: "Question 4?",
  flashcard_type: "multiple choice",
})

flashcard5 = rails_article.flashcards.create!({
  content: "Question 5?",
  flashcard_type: "multiple choice",
})


# Add answers
flashcard1.answers << Answer.all.sample(3)
flashcard2.answers << Answer.all.sample(3)
flashcard3.answers << Answer.all.sample(3)
flashcard4.answers << Answer.all.sample(3)
flashcard5.answers << Answer.all.sample(3)

# Add correct answer
flashcard1.update(correct_answers: [flashcard1.answers.first.id])
flashcard2.update(correct_answers: [
  flashcard2.answers.second.id,flashcard2.answers.first.id
  ])
flashcard3.update(correct_answers: [flashcard3.answers.last.id])
flashcard4.update(correct_answers: [flashcard4.answers.first.id])
flashcard5.update(correct_answers: [flashcard5.answers.first.id])

# New multiple choice flahscard for second article
flashcard2_1 = bjj_article.flashcards.create!({
  content: "Question 1 second article?",
  flashcard_type: "multiple choice",
})

flashcard2_2 = bjj_article.flashcards.create!({
  content: "Question 2 second article?",
  flashcard_type: "multiple choice",
})

flashcard2_3 = bjj_article.flashcards.create!({
  content: "Question 3 second article?",
  flashcard_type: "multiple choice",
})

# Add answers
flashcard2_1.answers << Answer.all.sample(3)
flashcard2_2.answers << Answer.all.sample(3)
flashcard2_3.answers << Answer.all.sample(3)

# Add correct answer
flashcard2_1.update(correct_answers: [flashcard2_1.answers.first.id])
flashcard2_2.update(correct_answers: [
                                    flashcard2_2.answers.second.id,flashcard2_2.answers.first.id
                                    ])
flashcard2_3.update(correct_answers: [flashcard2_3.answers.last.id])

puts "Done."