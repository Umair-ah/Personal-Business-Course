class Tut < ApplicationRecord
  acts_as_list
  belongs_to :course
  has_one_attached :video

  def user_has_access?(user)
    user.payments.exists?(course_id: self.course_id)
  end
  
end
