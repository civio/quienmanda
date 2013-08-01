class Post < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User

  acts_as_url :title, url_attribute: :slug
  def to_param
    slug
  end

  scope :published, -> { where(published: true) }

  # RailsAdmin configuration
  rails_admin do
    configure :published do 
      optional false 
    end
    configure :title do 
      optional false 
    end
    configure :author do
      inverse_of :posts
    end

    group :basic_info do
      label "Content"
      field :title
      field :content
      field :author
    end
    group :internal do
      label "Internal"
      field :published
      field :notes
    end
  end
end
