class UsePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.id == record.user_id
  end

  def update?
    user.id == record.user_id
  end
end
