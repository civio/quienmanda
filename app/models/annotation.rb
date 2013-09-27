class Annotation < ActiveRecord::Base
  belongs_to :photo
  belongs_to :entity

  has_paper_trail
end
