class Pro::PagesController < ApplicationController

  layout 'pro'

  def home
    @business = Business.find(params[:business_id])
    @perks = @business.perks
  end

end
