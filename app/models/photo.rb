class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  acts_as_url :title, url_attribute: :slug
  def to_param
    slug
  end

  scope :published, -> { where(published: true) }

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :title
      field :file
    end

    edit do
      group :basic_info do
        label "Content"
        field :title do
          optional false
        end
        field :file
        field :copyright
        field :published do
          optional false
        end
      end
    end
  end
end
