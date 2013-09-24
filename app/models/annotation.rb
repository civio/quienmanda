class Annotation < ActiveRecord::Base
  belongs_to :photo
  belongs_to :entity
end
