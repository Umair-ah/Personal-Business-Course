class StaticsController < ApplicationController
  def home
    @my_courses = current_user.access_to_courses.order(created_at: :desc)
    @user_payments = current_user.payments
  end
end