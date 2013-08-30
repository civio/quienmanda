class RelationType < ActiveRecord::Base
  has_many :relations, inverse_of: :relation_type

  has_paper_trail

  validates :description, presence: true, uniqueness: true
end
