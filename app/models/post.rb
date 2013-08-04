class Post < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User

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
      field :author
    end

    edit do
      group :basic_info do
        label "Content"
        field :title
        field :content, :ck_editor do 
          help 'Puedes insertar códigos como: [documentcloud url="..."] [quienmanda url="..." width="..."]'
        end
        field :author do
          inverse_of :posts
        end
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
