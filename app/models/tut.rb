class Tut < ApplicationRecord
  acts_as_list
  belongs_to :course
  has_many_attached :videos
  has_one :video

  validates :title, presence: true


  def user_has_access?(user)
    user.payments.exists?(course_id: self.course_id)
  end

  
end
