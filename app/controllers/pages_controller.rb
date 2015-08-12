class PagesController < ApplicationController
  def home
    @businesses = Business.all
  end

  def info_business
  end

  def info_cause
  end

  def about
  end

  def charte
  end

  def member_card
  end
end