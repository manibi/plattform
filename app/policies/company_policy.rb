class CompanyPolicy < ApplicationPolicy
  def company_dashboard?
    current_company?
  end

  def show?
    record.is_a? Company
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def current_company?
    record.is_a? Company
  end
end
