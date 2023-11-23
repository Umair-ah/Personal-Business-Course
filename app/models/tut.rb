class Tut < ApplicationRecord
  include AppendToHasManyAttached['videos']
  has_many_attached :videos
  belongs_to :course
  acts_as_list



  validates :title, presence: true

  before_save :remove_mp4_extension


  def user_has_access?(user)
    user.payments.exists?(course_id: self.course_id)
  end

  def remove_mp4_extension
    videos.each do |video_attachment|
      if video_attachment.filename.to_s.end_with?('.mp4')
        new_filename = video_attachment.filename.to_s.chomp('.mp4')
        video_attachment.blob.update(filename: new_filename)
      end
    end
  end

  def highlight_video
    video = ActiveStorage::Blob.find_by(filename: params[:filename])
    if params[:video_title] == video.filename
      puts "this is after you seleected the video!"
    end
  end

  
end
