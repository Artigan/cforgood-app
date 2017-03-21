class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
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
