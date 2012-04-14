class Micropost < ActiveRecord::Base
  # user_id is not accessible via the web
  attr_accessible :content
  belongs_to :user
  
  # a MICROpost has to have content
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
  
  # scope
  # Returns microposts from the users being followed by the given user.
  # optimization to fetch chunck from DB at a time, instead of all the content
  # the lambda function returns an argument for the scope, an SQL condition
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

    # Returns an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      followed_user_ids = %(SELECT followed_id FROM relationships
                            WHERE follower_id = :user_id)
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
            { user_id: user })
    end
  
  
  # def self.from_users_followed_by(user)
    # the followed_user_ids method is synthesized by Active Record based on the has_many :followed_users association (Listing 11.10); the result is that we need only append _ids to the association name to get the ids corresponding to the user.followed_users collectio
    # followed_user_ids = user.followed_user_ids.join(', ')
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  # end  
end
