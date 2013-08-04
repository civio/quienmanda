class Relation < ActiveRecord::Base
  belongs_to :source, foreign_key: :source_id, class_name: Entity, inverse_of: :relations_as_source
  belongs_to :target, foreign_key: :target_id, class_name: Entity, inverse_of: :relations_as_target

  validates :source, :target, presence: true
  validates :relation, presence: true

  def to_human
    "#{source && source.name} -> #{relation} -> #{target && target.name}"
  end

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :source
      field :relation
      field :target
      field :via
    end

    edit do
      group :basic_info do
        field :source
        field :relation
        field :target
        field :via
      end
      group :timeline do
        field :from
        field :to
        field :at
      end
      group :internal do
        field :published
        field :notes
      end
    end

    object_label_method do
      :to_human
    end
  end
end
