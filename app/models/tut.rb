class Tut < ApplicationRecord
  include AppendToHasManyAttached['videos'] # you can include it before or after, order does not matter, explanation below
  has_many_attached :videos
  belongs_to :course
  acts_as_list



  validates :title, presence: true


  def user_has_access?(user)
    user.payments.exists?(course_id: self.course_id)
  end

  
end
