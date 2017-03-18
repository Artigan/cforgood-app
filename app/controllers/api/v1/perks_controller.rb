class Api::V1::PerksController < Api::V1::BaseController

  before_action :set_perk, only: [ :show ]

  def show
  end

  private

  def set_perk
    @perk = Perk.includes(:perk_detail).find(params[:id])
    authorize @perk
  end
end
