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
  }
])
industriekauf = Profession.first
buero_management = Profession.second

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
  },
])

mozubi = Company.first
siemens = Company.second

# ! users
puts "Generate users"
# Authors
INDUSTRIEKAUF_AUTHORS = generate_author_licences(mozubi, 3)
BUERO_MANAGEMENT_AUTHORS = generate_author_licences(mozubi, 3)

# Students
SIEMENS_INDUSTRIEKAUF_STUDENTS = generate_student_licences(
  siemens, industriekauf.name, 3)
SIEMENS_BUERO_MANAGEMENT_STUDENTS = generate_student_licences(
  siemens, buero_management.name, 3)

industriekauf.users.create!(INDUSTRIEKAUF_AUTHORS)
industriekauf.users.create!(SIEMENS_INDUSTRIEKAUF_STUDENTS)

buero_management.users.create!(BUERO_MANAGEMENT_AUTHORS)
buero_management.users.create!(SIEMENS_BUERO_MANAGEMENT_STUDENTS)

# Store generated users in files
store_users(
  "#{Dir.pwd}/db/generated_users/industriekaufleute_authors.json", INDUSTRIEKAUF_AUTHORS)
store_users(
  "#{Dir.pwd}/db/generated_users/industriekaufleute_students.json", SIEMENS_INDUSTRIEKAUF_STUDENTS)
store_users(
  "#{Dir.pwd}/db/generated_users/buero_management_authors.json", BUERO_MANAGEMENT_AUTHORS)
store_users(
  "#{Dir.pwd}/db/generated_users/buero_management_students.json", SIEMENS_BUERO_MANAGEMENT_STUDENTS)

# ! Import data
puts "Import csv data to db"
puts "Start Industriekaufleute data..."

data_industriekaufleute = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_industriekaufleute.csv"), headers: true)

data_industriekaufleute.each do |row|
  # Topics
  industriekauf.topics.create!({ name: row[1] }) unless Topic.find_by(name: row[1])

  # Categories
  # ! categories have no description scraped
  category = find_category(row, 2, 14)
  topic = Topic.find_by(name: row[1])
  topic.categories.create!({
    title: category
  }) unless Category.find_by(title: category)

  # Articles
  article_name = row["Fachbegriff"]
  article_description = row["Definition"]
  db_category = Category.find_by(title: category)

  db_category.articles.create!({
    title: article_name,
    description: article_description,
    draft: false,
    published_at: Time.now
  })

  # Chapters
  db_article = Article.find_by(title: article_name)
  article_chapter1 = row["Erläuterung"]
  article_chapter2 = row["Praxisbeispiel aus der Wirtschaft"]
  article_chapter3 = row["Verwandte Themen"]

  db_article.chapters.create!({
    title: "Verwandte Themen",
    content: article_chapter3
  }) if row[22]


  db_article.chapters.create!({
    title: "Praxisbeispiel aus der Wirtschaft",
    content: article_chapter2
    }) if row[21]

  db_article.chapters.create!({
    title: "Erläuterung",
    content: article_chapter1
  }) if row[20]
end

puts "Industriekaufleute data...done"

