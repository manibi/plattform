require "securerandom"

def generate_student_licences(company, profession, licences_num)
  (0...licences_num).to_a.map do |i|
      {
        username: "#{company.downcase}-#{profession.downcase}-#{Time.now.getutc.to_i + i}",
        password: SecureRandom.hex[0..10]
      }
  end
end

def generate_author_licences(licences_num)
  (0...licences_num).to_a.map do |i|
     {
      username: "author-#{SecureRandom.hex[0..6]}",
      password: SecureRandom.hex[0..10],
      role: "author"
    }
  end
end

# def add_profession_to!(authors, profession_name)
#   authors.map do |author|
#     author[:profession] = profession_name
#     author
#   end
# end

def store_users(filepath_json_file, users_json_data)
  File.open(filepath_json_file, 'wb') do |file|
    file.write(JSON.generate(users_json_data))
  end
end