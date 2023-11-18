class Tut < ApplicationRecord
  acts_as_list
  belongs_to :course
  has_one_attached :video

  validates :title, presence: true
  validates :video, presence: { message: "is not present for upload" }


  def user_has_access?(user)
    user.payments.exists?(course_id: self.course_id)
  end
  
end
