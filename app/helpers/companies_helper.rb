module CompaniesHelper
  # :name, :address, :phone_number, :email, :contact_person_name
  def generate_company(attributes={})
    {
      name: attributes[:name],
      username: "#{attributes[:name].downcase}-#{SecureRandom.hex[0..10]}",
      password: SecureRandom.hex[0..10],
      address: attributes[:address],
      phone_number: attributes[:phone_number],
      email: attributes[:email],
      contact_person_name: attributes[:contact_person_name]
    }
  end
end
