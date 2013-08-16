class Fact < ActiveRecord::Base
  belongs_to :relation

  def summary
    properties.to_s
  end
end