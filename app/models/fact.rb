class Fact < ActiveRecord::Base
  has_and_belongs_to_many :relations

  scope :importer, ->(importer) { where(importer: importer) }

  # Return those facts that have not been processed yet, i.e. have no associated relations,
  # ordered by fact id (to avoid surprises when reviewing a dry-run import and then doing it)
  def Fact.unprocessed_facts
    # Rails 4 requires the .references bit
    # See http://blog.remarkablelabs.com/2012/12/what-s-new-in-active-record-rails-4-countdown-to-2013
    Fact.includes(:relations).where('relation_id IS NULL').references(:relations).order('facts.id ASC')
  end

  def summary
    properties.to_s
  end

  def to_s
    "#{importer} [#{summary}]"
  end
end