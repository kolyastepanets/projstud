class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user, :content, :commentable, presence: true

  default_scope { order('created_at ASC') }
end
