class Topic < ActiveRecord::Base
  belongs_to :entity  # Don't get confused, we _have_ an entity
  belongs_to :photo # Don't get confused, we _have_ a header photo

	validates :title, presence: true, uniqueness: true

	acts_as_url :title, url_attribute: :slug, only_when_blank: true
	def to_param
	  slug
	end

  scope :published, -> { where(published: true) }
end
