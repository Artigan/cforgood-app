class Api::V1::BusinessesController < Api::V1::BaseController

  before_action :set_business, only: [ :show ]

  def index
    # recherche comme pour la map
    # ou recherche pour l'index selon paramètre
  end

  def show
    # récupération busimess + perk + ...
  end

  def update
    # mise à jour du nombre de vue ou alors quand demande API mise à jour auto !
  end

  private

  def set_business
    @business = Business.find(params[:id])
    authorize @business
  end
end
