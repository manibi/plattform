class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard, :author_dashboard]

  def landing_page
  end

  def dashboard
  end

  def author_dashboard
  end
end
