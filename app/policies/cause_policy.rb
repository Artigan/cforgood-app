class CausePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def new?
    user == record
  end

  def create?
    true
  end
end
