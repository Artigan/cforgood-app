class BusinessPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user == record
  end

  def new?
    user == record
  end

  def home?
     user == record
  end

  def dashboard?
    user == record
  end
end
