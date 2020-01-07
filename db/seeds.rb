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

puts "Adding professions..."
profession = Profession.create!(name: 'Developer')


puts "Creating users..."
profession.users.create!({
  username: "login-string",
  password: "password"
})

puts "Creating topics..."
profession.topics.create!({
  name: "Back End Development"
})

profession.topics.create!({
  name: "Front End Development"
})

puts "Creating articles..."
profession.topics.first.articles.create!({
  title: "Ruby on Rails",
  description: "Ruby on Rails, sometimes known as 'RoR or just 'Rails, is an open source framework for Web development in Ruby, an object-oriented programming (OOP) language similar to Perl and Python"
})

profession.topics.first.articles.create!({
  title: "Javascript",
  description: "What is JavaScript ? JavaScript is a dynamic computer programming language. It is lightweight and most commonly used as a part of web pages, whose implementations allow client-side script to interact with the user and make dynamic pages. It is an interpreted programming language with object-oriented capabilities."
})

profession.topics.first.articles.create!({
  title: "React",
  description: "React (also known as React.js or ReactJS) is a JavaScript library for building user interfaces. It is maintained by Facebook and a community of individual developers and companies. React can be used as a base in the development of single-page or mobile applications."
})

# Articles for 2nd topic
5.times do |n|
  profession.topics.second.articles.create!({
    title: Faker::ProgrammingLanguage.name,
    description: Faker::Lorem.sentence(word_count: 3)
  })
end

puts "Creating chapters"
profession.topics.first.articles.first.chapters.create!({
  title: "Active Record",
  content: "In software engineering, the active record pattern is an architectural pattern found in software that stores in-memory object data in relational databases."
})

profession.topics.first.articles.first.chapters.create!({
  title: "Action View",
  content: "Action View templates are written using embedded Ruby in tags mingled with HTML. To avoid cluttering the templates with boilerplate code, a number of helper classes provide common behavior for forms, dates, and strings. It's also easy to add new helpers to your application as it evolves."
})

puts "Done."