class Relation < ActiveRecord::Base
  belongs_to :source, foreign_key: :source_id, class_name: Entity, inverse_of: :relations_as_source
  belongs_to :target, foreign_key: :target_id, class_name: Entity, inverse_of: :relations_as_target
  belongs_to :relation_type, inverse_of: :relations

  validates :source, :target, :relation_type, presence: true

  scope :published, -> { where(published: true) }

  def to_human
    "#{source && source.name} -> #{relation_type && relation_type.description} -> #{target && target.name}"
  end

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :needs_work
      field :source
      field :relation_type
      field :target
      field :via
    end

    edit do
      group :basic_info do
        field :source
        field :relation_type
        field :target
        field :via
        field :via2
        field :via3
      end
      group :timeline do
        field :from do
          strftime_format "%d/%m/%Y"
        end
        field :to do
          strftime_format "%d/%m/%Y"
        end
        field :at do
          strftime_format "%d/%m/%Y"
        end
      end
      group :internal do
        field :published do
          default_value true
        end
        field :needs_work do
          default_value false
        end
        field :notes
      end
    end

    object_label_method do
      :to_human
    end
  end
end
