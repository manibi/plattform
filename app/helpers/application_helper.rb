module ApplicationHelper
  def display_user_name(user)
    if user&.first_name&.last_name
      "#{user.first_name.capitalize} + #{user.last_name.capitalize}"
    else
      "Incomplete profile name"
    end
  end

  def calculate_percentage(num1, percentage_from_num2)
    return 0 if percentage_from_num2.zero?
    (num1 / percentage_from_num2) * 100
  end
end
