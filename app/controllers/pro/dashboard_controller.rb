class Pro::DashboardController < Pro::ProController

  skip_after_action :verify_authorized, only: :set_impersonation
  before_action :find_business, only: [:dashboard, :profile]

  def set_impersonation
    if current_business.supervising?(params[:impersonate_id])
      session[:impersonate_id] = params[:impersonate_id]
    else
      session[:impersonate_id] = nil
    end
    redirect_to :back
  end

  def dashboard
    @perks = @business.perks
    authorize @business
  end

  def profile
    5.times{ current_business.addresses.build }
    authorize @business
  end

  private

  def find_business
    id = session[:impersonate_id] || params[:business_id]
    @business = Business.find(id)
  end
end
