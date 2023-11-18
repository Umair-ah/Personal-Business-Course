require 'stripe'
Stripe.api_key = "sk_test_51NcIGEJdM2t98eyhyW2R6HDffCWMy4msgF16bpW3Mi20ihKOgpoPItOne2lVDSmqxUDZ4ehVJLnqAYErZvimN46h00fYFnRiOL"
class PaymentsController < ApplicationController
  before_action :set_course
  before_action :authenticate_user!

  def index
    if current_user.payments.exists?(course_id: params[:course_id])
      redirect_to my_courses_path, notice: "You Have already paid for the course! :)"
    else
      redirect_to course_tuts_path(@course)
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @line_items = Stripe::Checkout::Session.list_line_items(params[:session_id])
    unless Payment.exists?(user_id: current_user.id, course_id: @course.id)
      Payment.create(
        price: @session.amount_total / 100,
        user_id: current_user.id,
        course_id: @course.id,
        stripe_session_id: params[:session_id]
        )
    end
  end


  private
  def set_course
    @course = Course.find(params[:course_id])
  end

  def payment_params
    params.require(:payment).permit(:price, :user_id, :course_id)
  end


end