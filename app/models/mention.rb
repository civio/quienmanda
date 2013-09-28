class Mention < ActiveRecord::Base
  belongs_to :post, inverse_of: :mentions
  belongs_to :mentionee, polymorphic: true, inverse_of: :mentions
end
