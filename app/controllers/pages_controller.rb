class PagesController < ApplicationController

  def home
    @businesses = Business.joins(:perks).where("perks.permanent = ?", true).distinct
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

  def faq
  end
end
