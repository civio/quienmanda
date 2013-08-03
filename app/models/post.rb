class Post < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User

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
      field :author
    end

    edit do
      group :basic_info do
        label "Content"
        field :title do
          optional false
        end
        field :content, :ck_editor
        field :author do
          inverse_of :posts
        end
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
