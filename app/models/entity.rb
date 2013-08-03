class Entity < ActiveRecord::Base
  extend Enumerize
  enumerize :priority, in: {:high => 1, :medium => 2, :low => 3}

  acts_as_url :name, url_attribute: :slug, only_when_blank: true
  def to_param
    slug
  end

  validates :name, presence: true, uniqueness: true
  validates :priority, presence: true
  validates :description, length: { maximum: 90 }

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
          default_value true
        end
        field :name
        field :short_name
        field :description
        field :priority do
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
        field :published
        field :slug do
          help 'Leave blank for the URL slug to be auto-generated'
        end
        field :notes
      end
    end
  end
end
