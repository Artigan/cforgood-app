class Api::V1::PartnersController < Api::V1::BaseController

  acts_as_token_authentication_handler_for User, except: [ :index ]

  def index
    @lat_lng = set_coordinates(params[:lat], params[:lng])
    @ecosystem = Ecosystem.within(@lat_lng).first
    if @ecosystem.present?
      @partner = Partner.where(ecosystem_id: @ecosystem.id).first
      if @partner.present?
        render status: 200, json: { code_partner: @partner.code_partner }
      else
        render status: 404, json: { message: 'No code partner' }
      end
    else
      render status: 404, json: { message: 'No code partner' }
    end
  end

end
