class Member::ProspectsController < ApplicationController

  before_action :find_prospect, only: [:edit, :update]

  def create
    @prospect = current_user.prospects.new(prospect_params)
    @prospect.save
    respond_to :js
  end

  def update
    @prospect.update(prospect_params)
    respond_to do |format|
      format.html {redirect_to member_user_dashboard_path(current_user)}
      format.js {}
    end
  end

  private

  def find_prospect
    @prospect = Prospect.find(params[:id])
  end

  def prospect_params
    params.require(:prospect).permit(:id, :user_id, :name, :street, :zipcode, :city, :leader_name, :email, :canvassed)
  end

end

