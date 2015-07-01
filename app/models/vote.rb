class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, :votable, presence: true
  validates :score, inclusion: { in: [-1, 1] }
  validates :user_id, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
end
