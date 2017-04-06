class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def supervisor_account?
    user == record
  end

  def show?
    user == record
  end

  def update?
    user == record
  end
end
