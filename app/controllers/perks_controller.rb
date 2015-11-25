class PerksController < ApplicationController

  def index
    @perks = Perks.all
  end

end
