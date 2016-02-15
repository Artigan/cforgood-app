class Pro::PerksController < Pro::ProController

  before_action :find_perk, only: [:edit, :update]
  before_action :find_business, only: [:index, :new, :create]

  def index
    @perks = policy_scope(Perk)
  end

  def new
    @perk = Perk.new
    authorize @perk
  end

  def create
    @perk = @business.perks.build(perk_params)
    authorize @perk

    if @perk.save
      redirect_to pro_business_perks_path(@business)
    else
      render :new
    end
    # @perk.save
    # respond_to do |format|
    #   format.html {redirect_to :back}
    #   format.js {}
    # end
  end

  def edit
  end

  def update
    if @perk.update(perk_params)
      redirect_to pro_business_perks_path(current_business)
    else
     render :edit
    end
  end

  private

  def find_perk
     @perk = Perk.find(params[:id])
     authorize @perk
  end

  def find_business
    @business = Business.find(params[:business_id])
  end

  def perk_params
    params.require(:perk).permit(:perk, :description, :detail, :times, :start_date, :end_date, :perk_code, :picture, :permanent, :periodicity_id, :active, :appel, :durable, :flash)
  end
end
