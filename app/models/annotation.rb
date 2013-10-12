class Annotation < ActiveRecord::Base
  belongs_to :photo, touch: true
  belongs_to :entity, touch: true

  has_paper_trail
end
