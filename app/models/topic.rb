class Topic < ActiveRecord::Base
  has_one :entity

	validates :title, presence: true, uniqueness: true

	acts_as_url :title, url_attribute: :slug, only_when_blank: true
	def to_param
	  slug
	end
end
