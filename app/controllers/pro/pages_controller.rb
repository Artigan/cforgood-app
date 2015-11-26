class Pro::PagesController < ApplicationController

  layout 'pro'

  before_action :authenticate_business!

  def home
    @business = Business.find(params[:business_id])
    @perks = @business.perks
  end

end
