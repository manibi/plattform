require "securerandom"

def generate_student_licences(company, profession, licences_num)
  (0...licences_num).to_a.map do |i|
      {
        username: "#{company.name.downcase}-#{profession.downcase}-#{SecureRandom.hex[0..6]}",
        password: SecureRandom.hex[0..10],
        company_id: company.id
      }
  end
end

def generate_author_licences(company, licences_num)
  (0...licences_num).to_a.map do |i|
     {
      username: "author-#{SecureRandom.hex[0..6]}",
      password: SecureRandom.hex[0..10],
      role: "author",
      company_id: company.id
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