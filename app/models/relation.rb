class Relation < ActiveRecord::Base
  belongs_to :source, foreign_key: :source_id, class_name: Entity, inverse_of: :relations_as_source
  belongs_to :target, foreign_key: :target_id, class_name: Entity, inverse_of: :relations_as_target
  belongs_to :relation_type, inverse_of: :relations

  has_many :facts

  validates :source, :target, :relation_type, presence: true

  scope :published, -> { where(published: true) }

  def to_human
    "#{source && source.short_or_long_name} -> #{relation_type && relation_type.description} -> #{target && target.short_or_long_name}"
  end
end
