# frozen_string_literal: true

require 'csv'
require_relative './seed_helpers'

puts 'Cleaning DB...'
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
puts 'Add professions...'
Profession.create!([
                     {
                       name: 'Industriekaufleute'
                     },
                     {
                       name: 'Büromanagement'
                     },
                     {
                       name: 'Industriemechanik'
                     },
                     {
                       name: 'Groß-und Außerhandel'
                     },
                     {
                       name: 'Controlling'
                     }
                   ])
industriekauf     = Profession.first
buero_management  = Profession.second
industriemechanik = Profession.third
handel            = Profession.fourth
controlling       = Profession.last

# ! companies
puts 'Generate companies'
Company.create!([
                  {
                    username: 'mozubi',
                    password: '123456',
                    name: 'Mozubi',
                    email: 'contact@mozubi.com',
                    contact_person_name: 'Mark B.'
                  },
                  {
                    username: 'siemens',
                    password: '123456',
                    name: 'Siemens',
                    email: 'contact@siemens.com',
                    contact_person_name: 'Mary B.'
                  }
                ])

mozubi = Company.first
siemens = Company.second

# ! users
puts 'Generate admin'
# Admin
User.create!(
  username: "#{mozubi.name.downcase}-admin-1",
  password: '123456',
  company_id: mozubi.id,
  profession: controlling,
  first_name: 'Admin 1',
  last_name: 'Mozubi',
  role: :admin
)

# Student
User.create!([
               {
                 username: 'industriemechanik-student-1',
                 password: '123456',
                 company_id: siemens.id,
                 profession: industriemechanik,
                 role: :student
               },
               {
                 username: 'industriekauf-student-1',
                 password: '123456',
                 company_id: siemens.id,
                 profession: industriekauf,
                 role: :student
               },
               {
                 username: 'buero_management-student-1',
                 password: '123456',
                 company_id: siemens.id,
                 profession: buero_management,
                 role: :student
               },
               {
                 username: "#{siemens.name.downcase}-student-4",
                 password: '123456',
                 company_id: siemens.id,
                 profession: industriemechanik,
                 role: :student
               },
               {
                 username: "#{siemens.name.downcase}-student-5",
                 password: '123456',
                 company_id: siemens.id,
                 profession: industriemechanik,
                 role: :student
               },
               {
                 username: 'handel-student-1',
                 password: '123456',
                 company_id: siemens.id,
                 profession: handel,
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
puts 'Import csv data to db'
# puts "Start Industriekaufleute data..."
# data_industriekaufleute = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_industriekaufleute.csv"), headers: true)

# data_industriekaufleute.each do |row|
#   # Topics
#   industriekauf.topics.create!({ name: row[1] }) unless Topic.find_by(name: row[1])

#   # Categories
#   category1 = find_category(row, 2, 7)
#   category2 = find_category(row, 9, 11)
#   category3 = row[13]
#   category_title = [category1, category2, category3].compact.first

#   topic = Topic.find_by(name: row[1])
#   topic.categories.create!({
#     title: category_title
#     }) unless Category.find_by(title: category_title)

#     # Articles
#     db_category = Category.find_by(title: category_title)
#     article_name = row["Fachbegriff"].strip
#     if row["Inhalt"].include?("Artikel") && !Article.find_by(title: article_name)

#       article_description = row["Definition"]
#         db_category.articles.create!({
#           title: article_name,
#           description: article_description,
#           draft: false,
#           published_at: Time.now
#         })
#     end

#  # Chapters
#   db_article = Article.find_by(title: article_name)
#   article_chapter1 = row["Erläuterung"]
#   article_chapter2 = row["Praxisbeispiel aus der Wirtschaft"]
#   article_chapter3 = row["Verwandte Themen"]

#   if db_article && db_article.chapters.empty?
#     db_article.chapters.create!({
#       title: "Verwandte Themen",
#       content: article_chapter3
#     }) if row[22]

#     db_article.chapters.create!({
#       title: "Praxisbeispiel aus der Wirtschaft",
#       content: article_chapter2
#       }) if row[21]

#     db_article.chapters.create!({
#       title: "Erläuterung",
#       content: article_chapter1
#     }) if row[20]
#   end
# end

# puts "Industriekaufleute data...done"
puts 'Start Industiemechaniker data...'
data_industriemechanik = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_industriemechaniker.csv"), headers: true)

data_industriemechanik.each do |row|
  # Topics
  topic_name = row[1].strip
  unless Topic.find_by(name: row[1])
    industriemechanik.topics.create!(name: topic_name)
  end

  # Categories
  category = find_category(row, 2, 17)
  topic = Topic.find_by(name: row[1])
  unless Category.find_by(title: category)
    topic.categories.create!(
      title: category
    )
    end

  # Articles
  article_name = row['Fachbegriff'].strip
  db_category = Category.find_by(title: category)

  if row['Inhalt'].include?('Artikel') && db_category.articles.where(title: article_name).empty?
    article_description = row['Definition'].strip

    db_category.articles.create!(
      title: article_name,
      description: article_description,
      draft: false,
      published_at: Time.now
    )
  end

  # Chapters
  db_article = Article.find_by(title: article_name)
  article_chapter1 = row['Erläuterung']
  article_chapter2 = row['Praxisbeispiel']
  article_chapter3 = row['Verwandte Themen']

  if db_article&.chapters&.empty?
    if row[25]
      db_article.chapters.create!(
        title: 'Verwandte Themen',
        content: article_chapter3
      )
    end

    if row[24]
      db_article.chapters.create!(
        title: 'Praxisbeispiel',
        content: article_chapter2
      )
    end

    if row[23]
      db_article.chapters.create!(
        title: 'Erläuterung',
        content: article_chapter1
      )
    end
  end

  if db_article && row['Inhalt'].include?('Mehrfachantworten')
    quiz_question = row[63]
    answers = mutiple_choice_answers_for(row, 63)
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # For multiple correct answers
    add_multiple_choice_answers_for(flashcard)
  end

  # Multiple choice one correct answer
  if db_article && row['Inhalt'].include?('Mehrfachwahlaufgabe')
    quiz_question = row[28]
    answers = mutiple_choice_answers_for(row, 28)
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # One correct answer
    flashcard.update(correct_answers: [flashcard.answers.first.id])
  end

  if db_article && row['Inhalt'].include?('Rechenaufgabe')
    quiz_question = row[51]
    answers = mutiple_choice_answers_for(row, 51)
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # One correct answer
    flashcard.update(correct_answers: [flashcard.answers.first.id])
  end

  if db_article && row['Inhalt'].include?('Zuordnungsaufgabe')

  quiz_question = 'Zuordnungsaufgabe'
  answers = match_answers_flashcard_for(row, 76)
  flashcard = db_article.flashcards.create!(
    content: quiz_question,
    flashcard_type: 'match_answers'
  )

  # Add answers to choose from
  flashcard.answers << Answer.create!(answers)

  # Matching correct answers
  flashcard.update(correct_answers: flashcard.answers.pluck(:id).select.with_index { |_a, i| i.even? })
  end
end
puts 'Industiemechaniker data...done'
puts "Start Groß-und Außerhandel data..."
data_handel = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_handel.csv"), headers: true)

data_handel.each do |row|
  # Topics
  handel.topics.create!({ name: row[1] }) unless Topic.find_by(name: row[1])

  # Categories
  category = find_category(row, 2, 24).strip

  topic = Topic.find_by(name: row[1])
  topic.categories.create!({
    title: category
    }) unless Category.find_by(title: category)

    # Articles
    db_category = Category.find_by(title: category)
    article_name = row["Fachbegriff"].strip
    if row["Inhalt"].include?("Artikel") && !Article.find_by(title: article_name)

      article_description = row["Definition"]
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
  article_chapter2 = row["Praxisbeispiel aus der Wirtschaft"]
  article_chapter3 = row["Verwandte Themen"]

  if db_article && db_article.chapters.empty?
    db_article.chapters.create!({
      title: "Verwandte Themen",
      content: article_chapter3
    }) if row[33]

    db_article.chapters.create!({
      title: "Praxisbeispiel aus der Wirtschaft",
      content: article_chapter2
      }) if row[32]

    db_article.chapters.create!({
      title: "Erläuterung",
      content: article_chapter1
    }) if row[31]
  end

   # Multiple choice one correct answer
  if db_article && row['Inhalt'].include?('Mehrfachwahlaufgabe (Multiple Choice)')
    quiz_question = row[36]

    answers = mutiple_choice_answers_for(row, 35) # starts at index + 2
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # p flashcard.article.title
    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # One correct answer
    flashcard.update(correct_answers: [flashcard.answers.first.id])
  end

  if db_article && row['Inhalt'].include?('Rechenaufgabe')
    quiz_question = row["Beispiel-Rechnung "]
    answers = mutiple_choice_answers_for(row, 57)
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # One correct answer
    flashcard.update(correct_answers: [flashcard.answers.first.id])
  end

  if db_article && row['Inhalt'].include?('Zuordnungsaufgabe')

    quiz_question = 'Zuordnungsaufgabe'
    answers = match_answers_flashcard_for(row, 82)
    flashcard = db_article.flashcards.create!(
      content: quiz_question,
      flashcard_type: 'match_answers'
    )

    # Add answers to choose from
    flashcard.answers << Answer.create!(answers)

    # Matching correct answers
    flashcard.update(correct_answers: flashcard.answers.pluck(:id).select.with_index { |_a, i| i.odd? })
  end

  # For multiple correct answers
  if db_article && row['Inhalt'] == 'Mehrfachantwortaufgabe'
    quiz_question = row[70]
    answers = mutiple_choice_answers_for(row, 70)
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    add_multiple_choice_answers_for(flashcard)
  end

end
puts "Groß-und Außerhandel data...done"
puts 'Start Büromanagement data...'
data_bueromanagement = CSV.parse(File.read("#{Dir.pwd}/db/seed_files/data_bueromanagement.csv"), headers: true)

data_bueromanagement.each do |row|
  # Topics
  unless Topic.find_by(name: row[1])
    buero_management.topics.create!(name: row[1])
  end

  # Categories
  category = find_category(row, 2, 16).strip

  topic = Topic.find_by(name: row[1])
  unless Category.find_by(title: category)
    topic.categories.create!(
      title: category
    )
  end

  # Articles
  db_category = Category.find_by(title: category)
  article_name = (row[17] || row[19])

  if row['Inhalt'].include?('Artikel') && !Article.find_by(title: article_name)

    article_description = row['Definition']
    db_category.articles.create!(
      title: article_name,
      description: article_description,
      draft: false,
      published_at: Time.now
    )

  end

  # Chapters
  db_article = Article.find_by(title: article_name)
  article_chapter1 = row['Erläuterung']
  article_chapter2 = row['Praxisbeispiel']
  article_chapter3 = row['Verwandte Themen']

  if db_article&.chapters&.empty?
    db_article.chapters.create!(
      title: 'Verwandte Themen',
      content: article_chapter3
    ) if row[23]


    db_article.chapters.create!(
      title: 'Praxisbeispiel',
      content: article_chapter2
    ) if row[22]


    db_article.chapters.create!(
      title: 'Erläuterung',
      content: article_chapter1
    ) if row[21]
  end

  if db_article && row['Inhalt'].include?('Zuordnungsaufgabe')

    quiz_question = 'Zuordnungsaufgabe'
    answers = match_answers_flashcard_for(row, 73)
    flashcard = db_article.flashcards.create!(
      content: quiz_question,
      flashcard_type: 'match_answers'
    )

    # Add answers to choose from
    flashcard.answers << Answer.create!(answers)

    # Matching correct answers
    flashcard.update(correct_answers: flashcard.answers.pluck(:id).select.with_index { |_a, i| i.even? })
  end

  if db_article && row['Inhalt'].include?('Richtige Reihenfolge')
    quiz_question = row[37]

    answers = correct_order_answers_for(row, 39)

    flashcard = db_article.flashcards.create!(
      content: quiz_question,
      flashcard_type: 'correct_order'
    )

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # Matching correct answers
    flashcard.update(correct_answers: flashcard.answers.pluck(:id))
  end

  # Multiple choice one correct answer
  if db_article && row['Inhalt'].include?('Mehrfachwahlaufgabe (Multiple Choice)')
    quiz_question = row[26]

    answers = mutiple_choice_answers_for(row, 25) # starts at index + 2
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # p flashcard.article.title
    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    # One correct answer
    flashcard.update(correct_answers: [flashcard.answers.first.id])
  end
  # For multiple correct answers
  if db_article && row['Inhalt'] == 'Mehrfachantwortaufgabe'
    quiz_question = row[60]
    answers = mutiple_choice_answers_for(row, 60)
    flashcard = db_article.flashcards.create!(
      content: quiz_question.strip,
      flashcard_type: 'multiple_choice'
    )

    # Add answers to choose from
    add_flashcard_answers(flashcard, answers)

    add_multiple_choice_answers_for(flashcard)
  end
end
puts 'Büromanagement data...done'
