module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected
  def check_user
    if current_company
      flash.clear

      redirect_to company_dashboard_path and return
    elsif current_user
      flash.clear

      if current_user.student?
        redirect_to (current_user.exam_date.nil? ? welcome_path : dashboard_path) and return
      elsif current_user.author?
        redirect_to (current_user.email.blank? ? welcome_path : author_dashboard_path) and return
      end
    end
  end
end