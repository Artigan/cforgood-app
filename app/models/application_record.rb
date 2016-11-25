class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true

  include Modules::ModuleSlack

end
