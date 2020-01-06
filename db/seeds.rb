puts "Cleaning DB..."
Chapter.delete_all
UserArticle.delete_all
# Answer.delete_all
# UserFlashcard.delete_all
# Flashcard.delete_all
Article.delete_all
Topic.delete_all
User.delete_all
Profession.delete_all

puts 'Adding professions...'
profession = Profession.create!(name: 'Developer')


puts 'Creating users...'
profession.users.create!({
  username: 'login-string',
  password: 'password'
})

puts 'Creating topics...'
profession.topics.create!({
  name: 'Back End Development'
})

puts 'Creating articles...'
profession.topics.first.articles.create!({
  title: 'Ruby on Rails',
  description: 'Ruby on Rails, sometimes known as "RoR" or just "Rails," is an open source framework for Web development in Ruby, an object-oriented programming (OOP) language similar to Perl and Python'
})

profession.topics.first.articles.create!({
  title: 'React',
  description: 'React (also known as React.js or ReactJS) is a JavaScript library for building user interfaces. It is maintained by Facebook and a community of individual developers and companies. React can be used as a base in the development of single-page or mobile applications.'
})

puts 'Creating chapters'
profession.topics.first.articles.first.chapters.create!({
  title: 'Active Record',
  content: 'In software engineering, the active record pattern is an architectural pattern found in software that stores in-memory object data in relational databases.'
})

profession.topics.first.articles.first.chapters.create!({
  title: 'Action View',
  content: "Action View templates are written using embedded Ruby in tags mingled with HTML. To avoid cluttering the templates with boilerplate code, a number of helper classes provide common behavior for forms, dates, and strings. It's also easy to add new helpers to your application as it evolves."
})

puts 'Done.'