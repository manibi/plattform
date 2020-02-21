require "csv"
# require "securerandom"
require_relative "./seed_users/seed_users"


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

# ! users
puts "Generate users"
# Authors
INDUSTRIEKAUF_AUTHORS = generate_author_licences(3)
BUERO_MANAGEMENT_AUTHORS = generate_author_licences(3)

# Students
SIEMENS_INDUSTRIEKAUF_STUDENTS = generate_student_licences(
  "Siemens", industriekauf.name, 3)
SIEMENS_BUERO_MANAGEMENT_STUDENTS = generate_student_licences(
  "Siemens", buero_management.name, 3)

industriekauf.users.create!(INDUSTRIEKAUF_AUTHORS)
industriekauf.users.create!(SIEMENS_INDUSTRIEKAUF_STUDENTS)

buero_management.users.create!(BUERO_MANAGEMENT_AUTHORS)
buero_management.users.create!(SIEMENS_BUERO_MANAGEMENT_STUDENTS)

# Store generated users in files
store_users(
  "#{Dir.pwd}/db/seed_users/generated_users/industriekaufleute_authors.json", INDUSTRIEKAUF_AUTHORS)
store_users(
  "#{Dir.pwd}/db/seed_users/generated_users/industriekaufleute_students.json", SIEMENS_INDUSTRIEKAUF_STUDENTS)
store_users(
  "#{Dir.pwd}/db/seed_users/generated_users/buero_management_authors.json", BUERO_MANAGEMENT_AUTHORS)
store_users(
  "#{Dir.pwd}/db/seed_users/generated_users/buero_management_students.json", SIEMENS_BUERO_MANAGEMENT_STUDENTS)

 puts "Import data to db"
# puts Dir.pwd
data_industriekaufleute = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_industriekaufleute.csv"), headers: true)
# file1 = CSV.parse(File.read("data.csv"), headers: true)


# ! topics
puts "Store topics..."
# data_industriekaufleute.by_col[1].uniq.each do |topic|
#   industriekauf.topics.create!({ name: topic })
# end

# loop over rows
# if topic is stored
# else create topic
# if category is stored
# else create category
# then create article


puts "Generate categories"

