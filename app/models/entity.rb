class Entity < ActiveRecord::Base
  extend Enumerize
  enumerize :priority, in: {:high => 1, :medium => 2, :low => 3}

  acts_as_url :name, url_attribute: :slug
  def to_param
    slug
  end

  scope :published, -> { where(published: true) }
  scope :people, -> { where(person: true) }

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :priority
      field :name
      field :short_name
      field :description
    end

    edit do
      group :basic_info do
        label "Basic info"
        field :person do
          optional false
          default_value true
        end
        field :name do 
          optional false 
        end
        field :short_name
        field :description
        field :priority do
          optional false
          default_value :medium
        end
      end
      group :test do
        label "Social media"
        field :twitter_handle
        field :wikipedia_page
        field :facebook_page
        field :flickr_page
        field :linkedin_page
      end
      group :internal do
        label "Internal"
        field :published do
          optional false
        end
        field :notes
      end
    end
  end
end
