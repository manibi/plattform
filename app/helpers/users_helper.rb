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

  # company, profession, first_name, last_name, email
  def generate_student(attributes={})
    {
      username: "#{attributes[:company].downcase}-#{SecureRandom.hex[0..10]}",
      password: SecureRandom.hex[0..10],
      company: attributes[:company],
      profession: attributes[:profession],
      role: :student
    }
  end

  def save_author_credentials(authors, user)
    authors.each do |author|
      a = UserCredential.create!({
        username: author[:username],
        password: author[:password],
        user: user,
        company: author[:company],
        profession: author[:profession],
        role: author[:role]
        })
    end
  end
end
