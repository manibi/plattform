require "securerandom"

module UsersHelper
  # company, profession, first_name, last_name, email
  def generate_admin(attributes={})
    {
      username: "mozubi-#{SecureRandom.hex[0..10]}",
      password: SecureRandom.hex[0..10],
      company: attributes[:company],
      profession: attributes[:profession],
      first_name: attributes[:first_name],
      last_name: attributes[:last_name],
      email: attributes[:email],
      role: :admin
    }
  end

  # company should always be mozubi
  def generate_authors(company, profession, licences_num)
    (0...licences_num).to_a.map do |i|
       {
        username: "author-#{SecureRandom.hex[0..10]}",
        password: SecureRandom.hex[0..10],
        profession: profession,
        company: company,
        role: :author
      }
    end
  end

  def generate_students(company, profession, licences_num)
    (0...licences_num).to_a.map do |i|
       {
        username: "#{company.name.downcase}-#{SecureRandom.hex[0..10]}",
        password: SecureRandom.hex[0..10],
        profession: profession,
        company: company,
        role: :student
      }
    end
  end

  def save_author_credentials(authors, user)
    authors.each do |author|
      UserCredential.create({
        username: author[:username],
        password: author[:password],
        user: user,
        company: author[:company],
        profession: author[:profession],
        role: author[:role]
        })
    end
  end

  def save_students_credentials(students, user)
    students.each do |student|
      UserCredential.create!({
        username: student[:username],
        password: student[:password],
        user: user,
        company: student[:company],
        profession: student[:profession],
        role: student[:role]
        })
    end
  end

  def save_temporary_student_credentials(student)
    TemporaryUserCredential.create!({
      username: student[:username],
      password: student[:password],
      company: student[:company],
      profession: student[:profession],
      role: student[:role]
    })
  end
end
