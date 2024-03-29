class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [ :show, :update ]

  def create
    # render status: :unprocessable_entity, json: { error: "Zipcode or City are required"} if !user_params[:city].present? || !user_params[:zipcode].present?
    if user_params[:access_token].present?
      url = "https://graph.facebook.com/me?fields=email,picture&access_token="
      begin
        content = open(URI.encode(url + user_params[:access_token]))
        email = JSON.parse(content.string)["email"]
        image = JSON.parse(content.string)["picture"]
        return render status: 401, :json => {:error => "Email and facebook token do not match" }  if email != user_params[:email]
      rescue OpenURI::HTTPError #with this I handle if the access token is not ok
        return render status: 401, :json => {:error => "Invalid facebook token" }
      end
    end

    params = user_params.except(:access_token)
    if user_params[:access_token].present?
      params = params.merge(token: user_params[:access_token])
      params = params.merge(password: Devise.friendly_token[0,20])
      params = params.merge(picture: image["data"]["url"]) if image.present?
    end

    @user = User.new(params)
    authorize @user
    if @user.save
      render status: 200, json: { id: @user.id }
    else
      render status: :unprocessable_entity, json: { error: @user.errors.full_messages}
    end
  end

  def show
    @cause = @user.cause
    @payments = @user.payments.where(done: true).order('created_at asc')
    @total_donation = @payments.sum(&:donation) if @payments.present?
    @partner = Partner.find_by_code_partner(@user.code_partner) if @user.code_partner
    @beneficiary = Beneficiary.includes(:users).find_by_email(@user.email)
    @user_offering = @beneficiary.try(:users)
    if !@user.uses.first.present?
      if !@user.member
        @first_perk_offer = Business.find(ENV['BUSINESS_ID_CFORGOOD']).perks.active.first
      elsif @user.business_supervisor_id
        @first_perk_offer = Business.find(@user.business_supervisor_id).perks.active.first
      end
    end
    @uses_without_feedback = @user.uses.without_feedback
  end

  def update
    if user_params[:subscription] == "X"
      @user.stop_subscription!
      render status: 200, json: { status: "updated" }
    elsif user_params[:code_partner].present? && @user.code_partner.present? && user_params[:code_partner].upcase != @user.code_partner
      render status: :unprocessable_entity, json: { error: "A code_partner already filled"}
    elsif user_params.include?("cause_id") && !user_params[:cause_id].present?
      render status: :unprocessable_entity, json: { error: "Cause required"}
    elsif user_params.include?("subscription") && user_params[:subscription] != "M" && user_params[:subscription] != "Y"
      render status: :unprocessable_entity, json: { error: "Unknowm subscription value"}
    elsif ( user_params.include?("subscription") && !user_params.include?("amount") )  ||  ( user_params.include?("amount") && !user_params.include?("subscription") )
      render status: :unprocessable_entity, json: { error: "Subscription or amount are both required"}
    elsif ( user_params[:subscription] == "M" && ( user_params[:amount] < 1 ||  user_params[:amount] > 50 )) || ( user_params[:subscription] == "Y" && ( user_params[:amount] < 30 ||  user_params[:amount] > 500 ) )
      render status: :unprocessable_entity, json: { error: "Invalid value of subscription or amount"}
    elsif user_params[:amount].present? && !user_params[:subscription].present?
        render status: :unprocessable_entity, json: { error: "Subscription required if Amount present"}
    else
      old_acct_id = @user.cause.acct_id
      params = user_params.except(:stripeToken)
      if !@user.update(params)
        render status: :unprocessable_entity, json: { error: @user.errors.full_messages}
      else
        if user_params[:stripeToken].present? or user_params[:subscription].present? or user_params[:amount].present? or user_params[:code_partner].present?
          if !create_or_update_payment(@user, user_params)
            render status: :unprocessable_entity, json: { error: flash[:error] }
          else
            render status: 200, json: { status: "updated" }
          end
        elsif user_params[:cause_id].present?
          if !change_connected_account(@user, @user.cause.acct_id, old_acct_id)
            render status: :unprocessable_entity, json: { error: flash[:error] }
          else
            render status: 200, json: { status: "updated" }
          end
        else
          render status: 200, json: { status: "updated" }
        end
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user  # For Pundit
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :password,
      :access_token,
      :token,
      :birthday,
      :subscription,
      :amount,
      :code_partner,
      :street,
      :zipcode,
      :city,
      :cause_id,
      :picture,
      :remote_picture_url,
      :stripeToken)
  end
end
