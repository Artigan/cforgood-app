class PropectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.prospects.select(:user_id))
    end
  end

  def create?
    true
  end
end
