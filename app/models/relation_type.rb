class RelationType < ActiveRecord::Base
  has_many :relations, inverse_of: :relation_type

  validates :description, presence: true, uniqueness: true
end
