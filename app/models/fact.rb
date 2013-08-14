class Fact < ActiveRecord::Base

  def summary
    properties.to_s
  end

  # RailsAdmin configuration
  rails_admin do
    list do
      field :importer
      field :summary
    end

    edit do
      field :importer
      field :summary do
        read_only true
      end
    end
  end
end