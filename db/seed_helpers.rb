require "securerandom"

def generate_student_licences(company, profession, licences_num)
  (0...licences_num).to_a.map do |i|
      {
        username: "#{company.name.downcase}-#{profession.downcase}-#{SecureRandom.hex[0..6]}",
        password: SecureRandom.hex[0..10],
        company_id: company.id,
        first_name: "student-#{i}",
        last_name: "Test siemens"
      }
  end
end

def generate_author_licences(company, licences_num)
  (0...licences_num).to_a.map do |i|
     {
      username: "author-#{SecureRandom.hex[0..6]}",
      password: SecureRandom.hex[0..10],
      role: "author",
      company_id: company.id,
      first_name: "author-#{i}",
      last_name:  "test mozubi"
    }
  end
end

def store_users(filepath_json_file, users_json_data)
  File.open(filepath_json_file, 'wb') do |file|
    file.write(JSON.generate(users_json_data))
  end
end

# Find and return the category in the current row from the csv file
def find_category(row, start, finish)
  idx = (start..finish).to_a.filter { |i| row[i] }.first
  row[idx]
end

def mutiple_choice_answers_for(row, question_idx)
  {
    "#{row[question_idx + 2]}": row[question_idx + 3],
    "#{row[question_idx + 4]}": row[question_idx + 5],
    "#{row[question_idx + 6]}": row[question_idx + 7],
    "#{row[question_idx + 8]}": row[question_idx + 9],
    "#{row[question_idx + 10]}": row[question_idx + 11]
  }
end


def match_answers_flashcard_for(row, question_idx)
  (0..9).to_a.map do |i|
    { content: row[question_idx + i] }
  end
end

def add_flashcard_answers(flashcard, answers)
  answers.each do |answer, expl|
    flashcard.answers << Answer.create!({
      content: answer,
      explanation: expl
    })
  end
end

def add_multiple_choice_answers_for(flashcard)
  if flashcard.answers.third.content.start_with?("R:")
    flashcard.answers.third.update(
      content: flashcard.answers.third.content[2..-1].strip)

    correct_answers = [
      flashcard.answers.first.id,
      flashcard.answers.second.id,
      flashcard.answers.third.id
    ]
  else
    correct_answers = [
      flashcard.answers.first.id,
      flashcard.answers.second.id
    ]
  end
  flashcard.update(correct_answers: correct_answers)
end