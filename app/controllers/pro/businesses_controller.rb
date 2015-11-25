class Pro::BusinessesController < ApplicationController

  layout 'pro'

  before_action :authenticate_business! #, unless: :pages_controller?

  def show
    @business = Business.find(params[:id])
  end

end
