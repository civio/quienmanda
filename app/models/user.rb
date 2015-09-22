class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,  
         :omniauthable, :omniauth_providers => [:twitter]

  has_many :posts, foreign_key: :author_id
  has_many :photos, foreign_key: :author_id

  acts_as_voter

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        if auth.provider == 'twitter'
          user.name = auth.info.name
          user.email = auth.info.nickname+'@twitter.com'
        else
          user.email = ( auth.info.email ) ? auth.info.email : ''
        end
        user.password = Devise.friendly_token[0,20]
      end
  end
end
