class ApplicationRecord < ActiveRecord::Base

  require 'one_signal'

  include Modules::ModuleSlack
  include Modules::ModulePayment

  self.abstract_class = true

end
