class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  acts_as_taggable

  scope :published, -> { where(published: true) }

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :needs_work
      field :file
      field :footer
      field :tag_list
    end

    edit do
      group :basic_info do
        label "Content"
        field :file
        field :copyright
        field :footer
      end
      group :internal do
        field :published do
          default_value false
        end
        field :needs_work do
          default_value true
        end
        field :tag_list do
          label "Tags"
          partial 'tag_list_with_suggestions'
        end
      end
    end
  end
end
