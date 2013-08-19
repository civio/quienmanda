class Fact < ActiveRecord::Base
  has_and_belongs_to_many :relations

  def summary
    properties.to_s
  end
end