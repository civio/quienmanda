class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  acts_as_taggable

  acts_as_url :title, url_attribute: :slug, only_when_blank: true
  def to_param
    slug
  end

  validates :title, presence: true, uniqueness: true

  scope :published, -> { where(published: true) }

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :title
      field :file
      field :tag_list
    end

    edit do
      group :basic_info do
        label "Content"
        field :title
        field :file
        field :copyright
      end
      group :internal do
        field :published do
          optional false
        end
        field :slug do
          help 'Leave blank for the URL slug to be auto-generated'
        end
        field :tag_list do
          label "Tags"
          partial 'tag_list_with_suggestions'
        end
      end
    end
  end
end
