require 'stripe'
Stripe.api_key = "sk_test_51NcIGEJdM2t98eyhyW2R6HDffCWMy4msgF16bpW3Mi20ihKOgpoPItOne2lVDSmqxUDZ4ehVJLnqAYErZvimN46h00fYFnRiOL"

class TutsController < ApplicationController
  before_action :set_course, except: %i[remove_video show]
  before_action :set_tut, only: %i[edit remove_video update show destroy]
  before_action :authenticate_user!, only: %i[show]
  
  def index
    @tuts = @course.tuts.order(:position)
    if current_user
      unless current_user.payments.exists?(course_id: params[:course_id])
        current_user.set_payment_processor :stripe
        current_user.payment_processor.customer
        
        @checkout_session = current_user.payment_processor.checkout(
          mode: 'payment',
          line_items: @course.stripe_price_id,
          success_url: success_course_payments_url
          )
      end
    end
  end

  def new
    @tut = @course.tuts.build
  end

  def create
    @tut = @course.tuts.build(tut_params)
    if @tut.save
      redirect_to course_tuts_path(@course)
      flash[:notice] = "Video Uploaded!"
    else 
      render :new
    end
  end

  def edit

  end

  
  def update
    if @tut.update(tut_params)
      redirect_to course_tuts_path(@course)
    end
  end

  def update_position
    @tut = Tut.find(params[:id])
    @tut.insert_at(tut_params[:position].to_i)
    head :ok
  end

end