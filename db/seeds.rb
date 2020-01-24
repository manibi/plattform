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
  username: "author-login",
  password: "password",
  role: "author"
})

developer_profession.users.create!({
    username: "login-string",
    password: "password"
})

fighter_profession.users.create!({
  username: "login-string2",
  password: "password"
})

puts "Creating topics..."
developer_profession.topics.create!([
  {
    name: "Back End Development"
  },
  {
    name: "Front End Development"
  }
])

fighter_profession.topics.create!({
  name: "BJJ"
})

back_end_dev_topic  = developer_profession.topics.first
front_end_dev_topic = developer_profession.topics.second
bjj_topic           = fighter_profession.topics.first

puts "Creating articles..."
back_end_dev_topic.articles.create!([
  {
  title: "Ruby on Rails",
  description: "Ruby on Rails, sometimes known as 'RoR or just 'Rails, is an open source framework for Web development in Ruby, an object-oriented programming (OOP) language similar to Perl and Python"
  }
])

front_end_dev_topic.articles.create!([
  {
  title: "Javascript",
  description: "Suchergebnisse
  Hervorgehobenes Snippet aus dem Web
  What is JavaScript ? JavaScript is a dynamic computer programming language. It is lightweight and most commonly used as a part of web pages, whose implementations allow client-side script to interact with the user and make dynamic pages. It is an interpreted programming language with object-oriented capabilities."
  }
])

bjj_topic.articles.create!([
  {
  title: "Closed guard",
  description: "Basics"
  }
])

rails_article = back_end_dev_topic.articles.first
js_article    = front_end_dev_topic.articles.first
bjj_article   = bjj_topic.articles.first

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
flashcard1_1 = rails_article.flashcards.create!({
  content: "First Article: Question 1?",
  flashcard_type: "multiple_choice",
})

flashcard1_2 = rails_article.flashcards.create!({
  content: "First Article: Question 2?",
  flashcard_type: "multiple_choice",
})

flashcard1_3 = rails_article.flashcards.create!({
  content: "First Article: Question 3?",
  flashcard_type: "multiple_choice",
})

flashcard1_4 = rails_article.flashcards.create!({
  content: "First Article: Question 4?",
  flashcard_type: "multiple_choice",
})

flashcard1_5 = rails_article.flashcards.create!({
  content: "First Article: Question 5?",
  flashcard_type: "multiple_choice",
})

# Add answers
flashcard1_1.answers << Answer.all.sample(3)
flashcard1_2.answers << Answer.all.sample(3)
flashcard1_3.answers << Answer.all.sample(3)
flashcard1_4.answers << Answer.all.sample(3)
flashcard1_5.answers << Answer.all.sample(3)

# Add correct answer
flashcard1_1.update(correct_answers: [flashcard1_1.answers.first.id])
flashcard1_2.update(correct_answers: [
  flashcard1_2.answers.second.id,flashcard1_2.answers.first.id
  ])
flashcard1_3.update(correct_answers: [flashcard1_3.answers.last.id])
flashcard1_4.update(correct_answers: [flashcard1_4.answers.first.id])
flashcard1_5.update(correct_answers: [flashcard1_5.answers.first.id])

# New correct order flahscard for first article
flashcard_order1_1 = rails_article.flashcards.create!({
  content: "First Article: Question 1? Order",
  flashcard_type: "correct_order"
})

flashcard_order1_1.answers << Answer.all.sample(3)
flashcard_order1_1.update(correct_answers: [
  flashcard_order1_1.answers.last.id,
  flashcard_order1_1.answers.first.id,
  flashcard_order1_1.answers.second.id
])

# Flashcard - match answers - first article
flashcard_match_1_1 = rails_article.flashcards.create!({
  content: "First Article: Drag answers from the right column to match the left column",
  flashcard_type: "match_answers"
})
flashcard_match_1_1.answers << Answer.all.sample(6)
flashcard_match_1_1.update(correct_answers: [
  flashcard_match_1_1.answers.fifth.id,
  flashcard_match_1_1.answers.last.id,
  flashcard_match_1_1.answers.fourth.id
])

# Flashcard - input numbers - first article
flashcard_numbers1_1 = rails_article.flashcards.create!({
  content: "First article: insert numbers",
  flashcard_type: "input_numbers"
})
flashcard_numbers1_1.update(correct_answers: [ 10, 100, 1000, 10_000 ])


# Second topic first article
flashcard1_2_1 = js_article.flashcards.create!({
  content: "First Profession Second Article: Question 1?",
  flashcard_type: "multiple_choice",
})

flashcard1_2_2 = js_article.flashcards.create!({
  content: "First Profession Second Article: Question 2?",
  flashcard_type: "multiple_choice",
})

flashcard1_2_3 = js_article.flashcards.create!({
  content: "First Profession Second Article: Question 3?",
  flashcard_type: "multiple_choice",
})

# Add answers
flashcard1_2_1.answers << Answer.all.sample(3)
flashcard1_2_2.answers << Answer.all.sample(3)
flashcard1_2_3.answers << Answer.all.sample(3)


flashcard1_2_1.update(correct_answers: [flashcard1_2_1.answers.first.id])
flashcard1_2_2.update(correct_answers: [flashcard1_2_2.answers.first.id])
flashcard1_2_3.update(correct_answers: [flashcard1_2_3.answers.first.id])







# Second Profession first topic first article
# New multiple choice flahscard for first article
flashcard2_1_1 = bjj_article.flashcards.create!({
  content: "Second Profession: First Article: Question 1?",
  flashcard_type: "multiple_choice",
})

flashcard2_1_2 = bjj_article.flashcards.create!({
  content: "Second Profession: First Article: Question 2?",
  flashcard_type: "multiple_choice",
})

flashcard2_1_3 = bjj_article.flashcards.create!({
  content: "Second Profession: First Article: Question 3?",
  flashcard_type: "multiple_choice",
})

flashcard2_1_4 = bjj_article.flashcards.create!({
  content: "Second Profession: First Article: Question 4?",
  flashcard_type: "multiple_choice",
})

flashcard2_1_5 = bjj_article.flashcards.create!({
  content: "Second Profession: First Article: Question 5?",
  flashcard_type: "multiple_choice",
})

# Add answers
flashcard2_1_1.answers << Answer.all.sample(3)
flashcard2_1_2.answers << Answer.all.sample(3)
flashcard2_1_3.answers << Answer.all.sample(3)
flashcard2_1_4.answers << Answer.all.sample(3)
flashcard2_1_5.answers << Answer.all.sample(3)

# Add correct answer
flashcard2_1_1.update(correct_answers: [flashcard2_1_1.answers.first.id])
flashcard2_1_2.update(correct_answers: [
  flashcard2_1_2.answers.second.id,flashcard2_1_2.answers.first.id
  ])
flashcard2_1_3.update(correct_answers: [flashcard2_1_3.answers.last.id])
flashcard2_1_4.update(correct_answers: [flashcard2_1_4.answers.first.id])
flashcard2_1_5.update(correct_answers: [flashcard2_1_5.answers.first.id])

# New correct order flahscard for first article
flashcard_order2_1_1 = bjj_article.flashcards.create!({
  content: "Second Profession: First Article: Question 1? Order",
  flashcard_type: "correct_order"
})

flashcard_order2_1_1.answers << Answer.all.sample(3)
flashcard_order2_1_1.update(correct_answers: [
  flashcard_order2_1_1.answers.last.id,
  flashcard_order2_1_1.answers.first.id,
  flashcard_order2_1_1.answers.second.id
])

# Flashcard - match answers - first article
flashcard_match2_1_1 = bjj_article.flashcards.create!({
  content: "Second Profession: First Article: Drag answers from the right column to match the left column",
  flashcard_type: "match_answers"
})
flashcard_match2_1_1.answers << Answer.all.sample(6)
flashcard_match2_1_1.update(correct_answers: [
  flashcard_match2_1_1.answers.fifth.id,
  flashcard_match2_1_1.answers.last.id,
  flashcard_match2_1_1.answers.fourth.id
])

# Flashcard - input numbers - first article
flashcard_numbers2_1_1 = bjj_article.flashcards.create!({
  content: "Second Profession: First article: insert numbers",
  flashcard_type: "input_numbers"
})
flashcard_numbers2_1_1.update(correct_answers: [ 10, 100, 1000, 10_000 ])




puts "Done."