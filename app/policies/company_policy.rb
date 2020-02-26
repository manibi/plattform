class CompanyPolicy < ApplicationPolicy
  def company_dashboard?
    current_company?
  end

  def show?
    current_company?
  end

  def edit?
    update?
  end

  def update?
    current_company?
  end

  def user_details?
    current_company?
  end

  def company_dashboard?
    current_company?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def current_company?
    record == user
  end
end
