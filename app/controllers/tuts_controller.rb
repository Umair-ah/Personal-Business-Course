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

  def destroy
    if @tut.destroy
      redirect_to course_tuts_path(@course), notice: "Video Deleted!"
    end
  end
  


  def show
    unless @tut.user_has_access?(current_user) || current_user.try(:type)
      redirect_to course_payments_path(params[:course_id]), alert: "You Have Not Payed for the course yet!"
    end
    @course = Course.find(params[:course_id])
    @tuts = @course.tuts.all
  end

  private
    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_tut
      @tut = Tut.find(params[:id])
    end

    def tut_params
      params.require(:tut).permit(:course_id, :title, :video, :position)
    end

end