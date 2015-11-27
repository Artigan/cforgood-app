class Pro::ProController < ApplicationController
  before_action :authenticate_business!

  layout 'pro'

end
