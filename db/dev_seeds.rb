require "csv"
require "securerandom"

def generate_student_licences(company, branch, licences_num)
  (0...licences_num).to_a.map { |i| [
      username: "#{company.downcase}-#{branch.downcase}-#{Time.now.getutc.to_i + i}",
      password: SecureRandom.hex[0..10]
    ]
  }
end

def generate_author_licences(licences_num)
  (0...licences_num).to_a.map { |i| [
      username: "author-#{Time.now.getutc.to_i + i}",
      password: SecureRandom.hex[0..10],
      role: "author"
    ]
  }
end

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

puts "Import data to db"
# puts Dir.pwd
data_industriekaufleute = CSV.parse(File.read("#{Dir.pwd}/db//seed_data/industriekaufleute.csv"), headers: true)
# file1 = CSV.parse(File.read("data.csv"), headers: true)

puts "Add professions..."
Profession.create!([
  {
    name: "Industriekauf"
  }
])
industriekauf = Profession.first

puts "Store topics..."
data_industriekaufleute.by_col[1].uniq.each do |topic|
  industriekauf.topics.create!({ name: topic })
end

# ! todo - store generated users in files
puts "Generate users"
p INDUSTRIEKAUF_AUTHORS = generate_author_licences(3)
p SIEMENS_INDUSTRIEKAUF_STUDENTS = generate_student_licences("Siemens", "Industriekauf", 3)

industriekauf.users.create!(SIEMENS_INDUSTRIEKAUF_STUDENTS)
industriekauf.users.create!(INDUSTRIEKAUF_AUTHORS)

puts "Generate categories"

