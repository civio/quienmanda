class Entity < ActiveRecord::Base
  extend Enumerize

  enumerize :category, in: [:person, :company, :public_body]
end
