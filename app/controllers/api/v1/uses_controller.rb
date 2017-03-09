class Api::V1::UsesController < Api::V1::BaseController

  before_action :set_use, only: [ :update ]

  def create
    @use = current_user.uses.build(use_params)
    authorize @use
    if @use.save
      render status: 200, json: { id: @use.id }
    else
      render status: :unprocessable_entity, json: { error: @use.errors.full_messages}
    end
  end

  def update
    @use.feedback = true
    @use.like = false
    @use.unlike = false
    @use.unused = false
    if use_params[:feedback] == "like"
      @use.like = true
    elsif use_params[:feedback] == "unlike"
      @use.unlike = true
    elsif use_params[:feedback] == "unused"
      @use.unused = true
    else
      render status: :bad_request, json: { error: "Paramètres incorrects" }
    end

    if @use.save
      render status: 200, json: { status: "updated" }
    else
      render status: :unprocessable_entity, json: { error: @use.errors.full_messages}
    end
  end

  private

  def set_use
    @use = Use.find(params[:id])
    authorize @use
  end

  def use_params
    params.require(:use).permit(:id, :feedback, :perk_id)
  end
end
