class Fact < ActiveRecord::Base
  has_and_belongs_to_many :relations

  # Return those facts that have not been processed yet, i.e. have no associated relations
  def Fact.unprocessed_facts
    # Rails 4 requires the .references bit
    # See http://blog.remarkablelabs.com/2012/12/what-s-new-in-active-record-rails-4-countdown-to-2013
    Fact.includes(:relations).where('relation_id IS NULL').references(:relations)
  end

  def summary
    properties.to_s
  end
end