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
end
