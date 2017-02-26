class Api::V1::UsesController < Api::V1::BaseController

  before_action :set_use, only: [ :update ]

  def update
    @use.feedback = true
    if params[:feedback] == "like"
      @use.like = true
    elsif params[:feedback] == "unlike"
      @use.unliked = true
    elsif params[:feedback] == "unused"
      @use.unused = true
    else
      render json: { error: "Paramètres incirrects" }, status: :bad_request
    end

    if !@use.save
      render json: { error: @use.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def set_use
    use = Use.find(params[:id])
    authorize @use
  end

  def use_params
    params.require(:use).permit(:id, :feedback)
  end
end
