puts "Cleaning DB..."
Chapter.destroy_all
UserArticle.destroy_all
FlashcardAnswer.destroy_all
CustomExamAnswer.destroy_all
CustomExam.destroy_all
Answer.destroy_all
UserFlashcard.destroy_all
Flashcard.destroy_all
Article.destroy_all
Category.destroy_all
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
developer_profession.users.create!([
  {
    username: "login1-1",
    password: "password"
  },
  {
    username: "login1-2",
    password: "password"
  },
  {
    username: "author-login",
    password: "password",
    role: "author"
  }
])

fighter_profession.users.create!({
  username: "login2-1",
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

puts "Creating modules(categories)..."
back_end_dev_topic.categories.create!([
  {
    title: "Programming Language",
    description: "Ruby"
  },
  {
    title: "Database",
    description: "MySQL"
  }
])


front_end_dev_topic.categories.create!([
  {
  title: "Design",
  description: "Colors"
  }
])

bjj_topic.categories.create!([
  {
  title: "Defence",
  description: "Guard basics"
  }
])

#! Create terms(articles)
puts "Creating terms(articles)..."
back_end_dev_module  = back_end_dev_topic.categories.first
back_end_dev_module2  = back_end_dev_topic.categories.second
front_end_dev_module = front_end_dev_topic.categories.first
bjj_module           = bjj_topic.categories.first

back_end_dev_module.articles.create!([
  {
  title: "Ruby",
  description: "Ruby was mainly designed as a general-purpose scripting language, which provides the wide support for the different applications of ruby. It is mainly getting used for a web application, standard libraries, servers, and other system utilities. Ruby has one of the great strength is metaprogramming."
  },
  {
    title: "Python",
    description: "Python is a general purpose and high level programming language. You can use Python for developing desktop GUI applications, websites and web applications. Also, Python, as a high level programming language, allows you to focus on core functionality of the application by taking care of common programming tasks."
    },
])

back_end_dev_module2.articles.create!([
  {
  title: "MySQL",
  description: "MySQL is an open-source relational database management system. Its name is a combination of My, the name of co-founder Michael Widenius's daughter, and SQL, the abbreviation for Structured Query Language."
  }
])

front_end_dev_module.articles.create!([
  {
  title: "CSS",
  description: "Cascading Style Sheets, kurz CSS genannt, ist eine Stylesheet-Sprache für elektronische Dokumente und zusammen mit HTML und DOM eine der Kernsprachen des World Wide Webs. Sie ist ein sogenannter living standard und wird vom World Wide Web Consortium beständig weiterentwickelt."
  }
])

bjj_module.articles.create!([
  {
  title: "Closed guard",
  description: "Basics"
  }
])

ruby_article    = back_end_dev_module.articles.first
python_article  = back_end_dev_module.articles.second
mysql_article   = back_end_dev_module2.articles.first
css_article     = front_end_dev_module.articles.first
bjj_article     = bjj_module.articles.first

puts "Creating chapters"
ruby_article.chapters.create!([
  {
  title: "String",
  content: "A String object holds and manipulates an arbitrary sequence of bytes, typically representing characters."
  },
  {
    title: "Integer",
    content: "In Ruby, numbers without decimal points are called integers, and numbers with decimal points are usually called floating-point numbers or, more simply, floats (you must place at least one digit before the decimal point). An integer literal is simply a sequence of digits eg. 0, 123, 123456789."
  }
])

puts "Creating answers..."
10.times do |n|
  Answer.create!({
    content: Faker::Quote.most_interesting_man_in_the_world
  })
end

puts "Creating flashcards..."
#! Ruby article
# 5 Multiple choice flashcards
flashcard1_1 = ruby_article.flashcards.create!({
  content: "Ruby Article: Question 1?",
  flashcard_type: "multiple_choice",
})

flashcard1_2 = ruby_article.flashcards.create!({
  content: "Ruby Article: Question 2?",
  flashcard_type: "multiple_choice",
})

flashcard1_3 = ruby_article.flashcards.create!({
  content: "Ruby Article: Question 3?",
  flashcard_type: "multiple_choice",
})

flashcard1_4 = ruby_article.flashcards.create!({
  content: "Ruby Article: Question 4?",
  flashcard_type: "multiple_choice",
})

flashcard1_5 = ruby_article.flashcards.create!({
  content: "Ruby Article: Question 5?",
  flashcard_type: "multiple_choice",
})

# Add answers to choose from
flashcard1_1.answers << Answer.all.sample(3)
flashcard1_2.answers << Answer.all.sample(3)
flashcard1_3.answers << Answer.all.sample(3)
flashcard1_4.answers << Answer.all.sample(3)
flashcard1_5.answers << Answer.all.sample(3)

# Add correct answers
flashcard1_1.update(correct_answers: [flashcard1_1.answers.first.id])
flashcard1_2.update(correct_answers: [
  flashcard1_2.answers.second.id,flashcard1_2.answers.first.id
  ])
flashcard1_3.update(correct_answers: [flashcard1_3.answers.last.id])
flashcard1_4.update(correct_answers: [flashcard1_4.answers.first.id])
flashcard1_5.update(correct_answers: [flashcard1_5.answers.first.id])

# Drag and drop flashcard
flashcard_order1_1 = ruby_article.flashcards.create!({
  content: "First Article: Question 1? Order",
  flashcard_type: "correct_order"
})

flashcard_order1_1.answers << Answer.all.sample(3)
flashcard_order1_1.update(correct_answers: [
  flashcard_order1_1.answers.last.id,
  flashcard_order1_1.answers.first.id,
  flashcard_order1_1.answers.second.id
])

# Match answers
flashcard_match_1_1 = ruby_article.flashcards.create!({
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
flashcard_numbers1_1 = ruby_article.flashcards.create!({
  content: "First article: insert numbers",
  flashcard_type: "soll_ist"
})
flashcard_numbers1_1.update(correct_answers: [ 10, 100, 1000, 10_000 ])

#! Python article
# 3 Multiple choice flashcards
flashcard1_2_1 = python_article.flashcards.create!({
  content: "Python Article: Question 1?",
  flashcard_type: "multiple_choice",
})

flashcard1_2_2 = python_article.flashcards.create!({
  content: "Python Article: Question 2?",
  flashcard_type: "multiple_choice",
})

flashcard1_2_3 = python_article.flashcards.create!({
  content: "Python Article: Question 3?",
  flashcard_type: "multiple_choice",
})

# Add answers to choose from
flashcard1_2_1.answers << Answer.all.sample(3)
flashcard1_2_2.answers << Answer.all.sample(3)
flashcard1_2_3.answers << Answer.all.sample(3)

# Add correct answers
flashcard1_2_1.update(correct_answers: [flashcard1_2_1.answers.first.id])
flashcard1_2_2.update(correct_answers: [
  flashcard1_2_2.answers.second.id,flashcard1_2_2.answers.first.id
  ])
flashcard1_2_3.update(correct_answers: [flashcard1_2_3.answers.last.id])

#! MySQL article
# 3 Multiple choice flashcards
flashcard1_2_1_1 = mysql_article.flashcards.create!({
  content: "MySQL Article: Question 1?",
  flashcard_type: "multiple_choice",
})

flashcard1_2_1_2 = mysql_article.flashcards.create!({
  content: "MySQL Article: Question 2?",
  flashcard_type: "multiple_choice",
})

flashcard1_2_1_3 = mysql_article.flashcards.create!({
  content: "MySQL Article: Question 3?",
  flashcard_type: "multiple_choice",
})

# Add answers to choose from
flashcard1_2_1_1.answers << Answer.all.sample(3)
flashcard1_2_1_2.answers << Answer.all.sample(3)
flashcard1_2_1_3.answers << Answer.all.sample(3)

# Add correct answers
flashcard1_2_1_1.update(correct_answers: [flashcard1_2_1_1.answers.first.id])
flashcard1_2_1_2.update(correct_answers: [
  flashcard1_2_1_2.answers.second.id,flashcard1_2_1_2.answers.first.id
  ])
flashcard1_2_1_3.update(correct_answers: [flashcard1_2_1_3.answers.last.id])

#! CSS article
# 2 Drag and drop flashcards
flashcard_order1_3_1 = css_article.flashcards.create!({
  content: "CSS Article: Question 1 - Drag and Drop",
  flashcard_type: "correct_order"
})

flashcard_order1_3_1.answers << Answer.all.sample(3)
flashcard_order1_3_1.update(correct_answers: [
  flashcard_order1_3_1.answers.last.id,
  flashcard_order1_3_1.answers.first.id,
  flashcard_order1_3_1.answers.second.id
])

flashcard_order1_3_2 = css_article.flashcards.create!({
  content: "CSS Article: Question 2 - Drag and Drop",
  flashcard_type: "correct_order"
})

flashcard_order1_3_2.answers << Answer.all.sample(3)
flashcard_order1_3_2.update(correct_answers: [
  flashcard_order1_3_2.answers.second.id,
  flashcard_order1_3_2.answers.last.id,
  flashcard_order1_3_2.answers.first.id,
])

# Match answers
flashcard_match1_3_3 = css_article.flashcards.create!({
  content: "CSS Article: Drag answers from the right column to match the left column",
  flashcard_type: "match_answers"
})
flashcard_match1_3_3.answers << Answer.all.sample(6)
flashcard_match1_3_3.update(correct_answers: [
  flashcard_match1_3_3.answers.fourth.id,
  flashcard_match1_3_3.answers.fifth.id,
  flashcard_match1_3_3.answers.last.id,
])

# Input numbers soll/haben
flashcard_numbers1_3_4 = css_article.flashcards.create!({
  content: "First article: insert numbers",
  flashcard_type: "soll_ist"
})
flashcard_numbers1_3_4.update(correct_answers: [ 10, 100, 1000, 10_000 ])

# Input numbers table
flashcard_numbers1_3_5 = css_article.flashcards.create!({
  content: "First article: insert numbers",
  flashcard_type: "table_quiz"
})
flashcard_numbers1_3_5.answers << Answer.create!([
  { content: "Input"  },
  { content: "Output" },
  { content: "Costs"  },
  { content: "Profit" }
])
flashcard_numbers1_3_5.update(correct_answers: [ 10, 100, 1000, 10_000, 10, 100, 1000, 10_000 ])

#! Bjj Article
# Input numbers soll/haben
flashcard_numbers2_1_1 = bjj_article.flashcards.create!({
  content: "BJJ article: insert numbers",
  flashcard_type: "soll_ist"
})
flashcard_numbers2_1_1.update(correct_answers: [ 10, 100, 1000, 10_000 ])

puts "Done."