puts "Cleaning DB..."
# UserArticle.delete_all
# Chapter.delete_all
# UserArticle.delete_all
# Answer.delete_all
# UserFlashcard.delete_all
# Flashcard.delete_all
# Article.delete_all
# Topic.delete_all
User.delete_all
Profession.delete_all

puts 'Adding professions...'
profession = Profession.create!(name: 'Developer')


puts 'Creating users...'
profession.users.create!({
  username: 'login-string',
  password: 'password'
})

puts 'Done.'