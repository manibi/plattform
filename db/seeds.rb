require "csv"
require_relative "./seed_helpers"

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
UserCredential.destroy_all
CompanyCredential.destroy_all
User.destroy_all
Profession.destroy_all
Company.destroy_all

# ! professions
puts "Add professions..."
Profession.create!([
  {
    name: "Industriekaufleute"
  },
  {
    name: "Büromanagement"
  },
  {
    name: "Industriemechanik"
  },
  {
    name: "Controlling"
  }
])
industriekauf    = Profession.first
buero_management = Profession.second
industriemechanik = Profession.third
controlling      = Profession.last

# ! companies
puts "Generate companies"
Company.create!([
  {
    username: "mozubi",
    password: "123456",
    name: "Mozubi",
    email: "contact@mozubi.com",
    contact_person_name: "Mark B."
  },
  {
    username: "siemens",
    password: "123456",
    name: "Siemens",
    email: "contact@siemens.com",
    contact_person_name: "Mary B."
  }
])

mozubi = Company.first
siemens = Company.second

# ! users
puts "Generate admin"
# Admin
User.create!({
  username: "#{mozubi.name.downcase}-admin-1",
  password: "123456",
  company_id: mozubi.id,
  profession: controlling,
  first_name: "Admin 1",
  last_name: "Mozubi",
  role: :admin
})

# Student
User.create!([
  {
    username: "#{siemens.name.downcase}-student-1",
    password: "123456",
    company_id: siemens.id,
    profession: industriemechanik,
    role: :student
  },
  {
    username: "#{siemens.name.downcase}-student-2",
    password: "123456",
    company_id: siemens.id,
    profession: industriekauf,
    role: :student
  },
  {
    username: "#{siemens.name.downcase}-student-3",
    password: "123456",
    company_id: siemens.id,
    profession: buero_management,
    role: :student
  }
])

# Authors
# INDUSTRIEKAUF_AUTHORS = generate_author_licences(mozubi, 3)
# BUERO_MANAGEMENT_AUTHORS = generate_author_licences(mozubi, 3)

# Students
# SIEMENS_INDUSTRIEKAUF_STUDENTS = generate_student_licences(
#   siemens, industriekauf.name, 3)
# SIEMENS_BUERO_MANAGEMENT_STUDENTS = generate_student_licences(
#   siemens, buero_management.name, 3)

# industriekauf.users.create!(INDUSTRIEKAUF_AUTHORS)
# industriekauf.users.create!(SIEMENS_INDUSTRIEKAUF_STUDENTS)

# buero_management.users.create!(BUERO_MANAGEMENT_AUTHORS)
# buero_management.users.create!(SIEMENS_BUERO_MANAGEMENT_STUDENTS)

# Store generated users in files
# store_users(
#   "#{Dir.pwd}/db/generated_users/industriekaufleute_authors.json", INDUSTRIEKAUF_AUTHORS)
# store_users(
#   "#{Dir.pwd}/db/generated_users/industriekaufleute_students.json", SIEMENS_INDUSTRIEKAUF_STUDENTS)
# store_users(
#   "#{Dir.pwd}/db/generated_users/buero_management_authors.json", BUERO_MANAGEMENT_AUTHORS)
# store_users(
#   "#{Dir.pwd}/db/generated_users/buero_management_students.json", SIEMENS_BUERO_MANAGEMENT_STUDENTS)

# ! Import data
puts "Import csv data to db"
# puts "Start Industriekaufleute data..."

# data_industriekaufleute = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_industriekaufleute.csv"), headers: true)

# data_industriekaufleute.each do |row|
#   # Topics
#   industriekauf.topics.create!({ name: row[1] }) unless Topic.find_by(name: row[1])

#   # Categories
#   # ! categories have no description scraped
#   category = find_category(row, 2, 14)
#   topic = Topic.find_by(name: row[1])
#   topic.categories.create!({
#     title: category
#   }) unless Category.find_by(title: category)

#   # Articles
#  if row["Inhalt"].include?("Artikel") && !db_category.articles.where(title: article_name).exists?
#     article_name = row["Fachbegriff"]
#     article_description = row["Definition"]
#     db_category = Category.find_by(title: category)

#     db_category.articles.create!({
#       title: article_name,
#       description: article_description,
#       draft: false,
#       published_at: Time.now
#     })
#   end
# end

#  # Chapters
#   db_article = Article.find_by(title: article_name)
#   article_chapter1 = row["Erläuterung"]
#   article_chapter2 = row["Praxisbeispiel aus der Wirtschaft"]
#   article_chapter3 = row["Verwandte Themen"]

#  if db_article && db_article.chapters.empty?
#   db_article.chapters.create!({
#     title: "Verwandte Themen",
#     content: article_chapter3
#   }) if row[22]


#   db_article.chapters.create!({
#     title: "Praxisbeispiel aus der Wirtschaft",
#     content: article_chapter2
#     }) if row[21]

#   db_article.chapters.create!({
#     title: "Erläuterung",
#     content: article_chapter1
#   }) if row[20]
#  end
# end

puts "Industriekaufleute data...done"
puts "Start Industiemechaniker data..."
data_industriemechanik = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_industriemechaniker.csv"), headers: true)

data_industriemechanik.each do |row|
    # Topics
    topic_name = row[1].strip
    industriemechanik.topics.create!({ name: topic_name }) unless Topic.where(name: topic_name).exists?

  # Categories
  category = find_category(row, 2, 17)
  topic = Topic.find_by(name: row[1])
  topic.categories.create!({
    title: category
  }) unless Category.find_by(title: category)

  # Articles
  article_name = row["Fachbegriff"].strip
  db_category = Category.find_by(title: category)

  if row["Inhalt"].include?("Artikel") && db_category.articles.where(title: article_name).empty?
    article_description = row["Definition"].strip

    db_category.articles.create!({
      title: article_name,
      description: article_description,
      draft: false,
      published_at: Time.now
    })
  end

  # Chapters
  db_article = Article.find_by(title: article_name)
  article_chapter1 = row["Erläuterung"]
  article_chapter2 = row["Praxisbeispiel"]
  article_chapter3 = row["Verwandte Themen"]

  if db_article && db_article.chapters.empty?
    db_article.chapters.create!({
      title: "Verwandte Themen",
      content: article_chapter3
    }) if row[25]


    db_article.chapters.create!({
      title: "Praxisbeispiel",
      content: article_chapter2
      }) if row[24]

    db_article.chapters.create!({
      title: "Erläuterung",
      content: article_chapter1
    }) if row[23]
  end

  # if quiz_question = row[28]
  #   answers = mutiple_choice_answers_for(row, 28)
  # elsif quiz_question = row[40]
  #   answers = mutiple_choice_answers_for(row, 40)
  # elsif quiz_question = row[63]
  #   answers = mutiple_choice_answers_for(row, 63)
  # end

  if db_article && row["Inhalt"].include?("Mehrfachantworten")# && db_article.flashcards.where(content: quiz_question.strip).empty?

    quiz_question = row[63]
    answers = mutiple_choice_answers_for(row, 63)
    flashcard = db_article.flashcards.create!({
      content: quiz_question.strip.capitalize,
      flashcard_type: "multiple_choice"
    })

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # For multiple correct answers
    add_multiple_choice_answers_for(flashcard)
  end
end
puts "Industiemechaniker data...done"

