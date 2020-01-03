class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def landing_page
  end

  def dashboard
  end
end
