class Entity < ActiveRecord::Base
  has_many :entity_photo_associations, dependent: :delete_all
  has_many :related_photos, through: :entity_photo_associations, source: :photo

  has_many :relations_as_source, foreign_key: :source_id, class_name: Relation, inverse_of: :source
  has_many :relations_as_target, foreign_key: :target_id, class_name: Relation, inverse_of: :target

  has_paper_trail
  
  include PgSearch
  multisearchable :against => [:name, :short_name, :description], :if => :published?

  mount_uploader :avatar, AvatarUploader

  # Note: sync_url=true won't work here, because we are using a function (short_or_long_name),
  # so acts_as_url (Stringex) can't detect when the attribute has changed. Bug or feature?
  acts_as_url :short_or_long_name, url_attribute: :slug, only_when_blank: true
  def to_param
    slug
  end

  # Non-persistent attribute used while importing, to highlight import results
  attr_accessor :created_by_import

  # Priorities
  PRIORITIES = [PRIORITY_HIGH = '1', PRIORITY_MEDIUM = '2', PRIORITY_LOW = '3']
  def priority_enum
    [ [ 'High', PRIORITY_HIGH ], [ 'Medium', PRIORITY_MEDIUM ], [ 'Low', PRIORITY_LOW ] ]
  end

  validates :name, presence: true, uniqueness: true
  validates :priority, inclusion: {in: PRIORITIES}
  validates :description, length: { maximum: 90 }

  scope :published, -> { where(published: true) }
  scope :people, -> { where(person: true) }
  scope :organizations, -> { where(person: false) }

  # Returns the short name if present, the long one otherwise
  def short_or_long_name
    (short_name.nil? || short_name.blank?) ? name : short_name
  end

  # Returns all the relations an entity is involved in.
  #   This is cleaner than prefetching relations_as_source, adding to relations_as_source...
  def relations
    Relation.where('source_id = ? or target_id = ?', self, self)
  end
end
