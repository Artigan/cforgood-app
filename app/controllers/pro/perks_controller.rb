class Pro::PerksController < Pro::ProController

  before_action :find_perk, only: [:edit, :update, :destroy]
  before_action :find_business, only: [:index, :new, :create]

  def index
    @perks = policy_scope(Perk).undeleted
  end

  def new
    @perk = Perk.new
    authorize @perk
  end

  def create
    @perk = @business.perks.build(perk_params)
    authorize @perk

    respond_to do |format|
      if @perk.save
        format.html { redirect_to pro_business_perks_path(@business) }
        format.js {}
      else
        format.html { render :new }
        format.js {}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @perk.update(perk_params)
        format.html { redirect_to pro_business_perks_path(current_business) }
        format.js {}
      else
        format.html { render :edit }
        format.js {}
      end
    end
  end

  def destroy
    if @perk.nb_views > 0 || @perk.uses.count > 0
      @perk.deleted!
    else
      @perk.destroy
    end
    redirect_to pro_business_perks_path(current_business)
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
    params.require(:perk).permit(:name, :description, :perk_detail_id, :times, :start_date, :end_date, :perk_code, :picture, :active, :appel, :durable, :flash)
  end
end
