puts "Cleaning DB..."
# UserArticle.delete_all
# Chapter.delete_all
# UserArticle.delete_all
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
  title: "Ruby on Rails",
  description: 'Ruby on Rails, sometimes known as "RoR" or just "Rails," is an open source framework for Web development in Ruby, an object-oriented programming (OOP) language similar to Perl and Python'
})

puts 'Done.'