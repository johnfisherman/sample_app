# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
    attr_accessible :name, :email, :password, :password_confirmation
    has_secure_password
    has_many :microposts, dependent: :destroy
    has_many :relationships, foreign_key: "follower_id", dependent: :destroy
    # user.followeds is rather awkward; far more natural is to use “followed users” as a plural of “followed”, and write instead user.followed_users for the array of followed users
    # Rails allows us to override the default
    has_many :followed_users, through: :relationships, source: :followed
    
    # ReverseRelationship class doesn't exist
    has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
    # source optional
    has_many :followers, through: :reverse_relationships, source: :follower
    before_save :create_remember_token
    
    # presence always beats presents. And uses blank? method, too. So, :name = "   " is invalid.
    validates :name, presence: true, length: { maximum: 50}
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: valid_email_regex },
                      uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 6 }
    
    def feed
      Micropost.from_users_followed_by(self)
      # This is preliminary. See "Following users" for the full implementation.
      # Micropost.where("user_id = ?", id)
      # or, simply
      # microposts
    end
    
    def following?(other_user)
      # equivalent to self.relationships.find_by_followed_id(other_user.id)
      relationships.find_by_followed_id(other_user.id)
    end
  
    def follow!(other_user)
      relationships.create!(followed_id: other_user.id)
    end
    
    def unfollow!(other_user)
      relationships.find_by_followed_id(other_user.id).destroy
    end    
    
      
    private
      # attribute remember token on user sign up
      def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
      end
    
end
