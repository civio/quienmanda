class Entity < ActiveRecord::Base
  extend Enumerize
  enumerize :category, in: [:person, :company, :public_body]
  enumerize :priority, in: {:high => 1, :medium => 2, :low => 3}

  scope :people, where(category: :person)

  # RailsAdmin configuration
  rails_admin do
    configure :category do 
      optional false 
      default_value :person
    end
    configure :priority do 
      optional false 
      default_value :medium
    end
    configure :name do 
      optional false 
    end

    group :basic_info do
      label "Basic info"
      field :category
      field :name
      field :short_name
      field :description
      field :priority
    end
    group :test do
      label "Social media"
      field :twitter_handle
      field :wikipedia_page
      field :facebook_page
      field :flickr_page
      field :linkedin_page
    end
    group :notes do
      field :notes
    end
  end
end
