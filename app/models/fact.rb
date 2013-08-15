class Fact < ActiveRecord::Base
  belongs_to :relation

  def summary
    properties.to_s
  end

  # RailsAdmin configuration
  rails_admin do
    list do
      field :importer
      field :relation
      field :summary
    end

    edit do
      field :importer
      field :relation do
        read_only true
      end
      field :summary do
        read_only true
      end
    end
  end
end