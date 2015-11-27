class PerkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(business_id: user.perks.select(:business_id))
    end
  end
end
