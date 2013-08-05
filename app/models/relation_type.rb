class RelationType < ActiveRecord::Base
  has_many :relations, inverse_of: :relation_type

  validates :description, presence: true, uniqueness: true
  
  # RailsAdmin configuration
  rails_admin do
    list do
      field :description
    end

    edit do
      field :description
      field :relations do
        read_only true
      end
    end

    object_label_method do
      :description
    end
  end
end
