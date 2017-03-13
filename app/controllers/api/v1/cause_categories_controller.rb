class Api::V1::CauseCategoriesController < Api::V1::BaseController

  def index
   @cause_categories = CauseCategory.all
   authorize @cause_categories
  end

end
