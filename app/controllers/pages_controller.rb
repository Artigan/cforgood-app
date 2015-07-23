class PagesController < ApplicationController
  def home
    @businesses = Business.all
  end

  def business
  end

  def charity
  end

  def vision
  end
end