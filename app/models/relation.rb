class Relation < ActiveRecord::Base
  belongs_to :source, foreign_key: :source_id, class_name: Entity, inverse_of: :relations_as_source
  belongs_to :target, foreign_key: :target_id, class_name: Entity, inverse_of: :relations_as_target
  belongs_to :relation_type, inverse_of: :relations

  has_paper_trail

  has_and_belongs_to_many :facts

  validates :source, :target, :relation_type, presence: true

  scope :published, -> { where(published: true) }

  # Collect all the different sources available (entered manually or automatically)
  def sources
    sources = []
    sources << via unless via.blank?
    sources << via2 unless via2.blank?
    sources << via3 unless via3.blank?
    facts.each {|fact| sources << fact.properties['via'] unless fact.properties['via'].blank? }
    sources
  end

  def to_s
    "#{source && source.short_or_long_name} -> #{relation_type && relation_type.description} -> #{target && target.short_or_long_name}"
  end
end
