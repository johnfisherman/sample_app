class Micropost < ActiveRecord::Base
  # user_id is not accessible via the web
  attr_accessible :content
  belongs_to :user
  
  # a MICROpost has to have content
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
end
