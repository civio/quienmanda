class Post < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User

  acts_as_url :title, url_attribute: :slug, only_when_blank: true
  def to_param
    slug
  end

  validates :title, presence: true, uniqueness: true
  validates :author, presence: true

  scope :published, -> { where(published: true) }

  # RailsAdmin configuration
  rails_admin do
    list do
      field :published, :toggle
      field :needs_work
      field :title
      field :author
    end

    edit do
      group :basic_info do
        label "Content"
        field :title
        field :content, :ck_editor do 
          help 'Puedes insertar códigos como: [dc url="..."] [qm url="..." text="..."] [gdocs url="..."]'
        end
        field :author do
          inverse_of :posts
        end
      end
      group :internal do
        label "Internal"
        field :published do
          default_value false
        end
        field :needs_work do
          default_value true
        end
        field :slug do
          help 'Leave blank for the URL slug to be auto-generated'
        end
        field :notes
      end
    end
  end
end
