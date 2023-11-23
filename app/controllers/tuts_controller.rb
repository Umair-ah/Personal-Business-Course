require 'stripe'
Stripe.api_key = "sk_test_51NcIGEJdM2t98eyhyW2R6HDffCWMy4msgF16bpW3Mi20ihKOgpoPItOne2lVDSmqxUDZ4ehVJLnqAYErZvimN46h00fYFnRiOL"

class TutsController < ApplicationController
  # These methods are called at the start of every REQUEST (i.e POST, GET, PATCH, DELETE)
  before_action :set_course, except: %i[remove_video edit_filename_post delete_file_post]
  before_action :set_tut, only: %i[edit remove_video update destroy edit_filename_post edit_filename delete_file_post]
  before_action :authenticate_user!, except: %i[index]

  def delete_file_post
    if @tut.videos.find_by(blob_id: params[:blob_id]).purge_later
      redirect_to course_tut_path(@tut.course, @tut, params[:blob_id])
      flash.now[:notice] = "Video Deleted!"
    end
  end

  def edit_filename_post
    @video_attrs = ActiveStorage::Blob.find_by(id: params[:blob_id])
    @video_attrs.filename = params[:file_name]
  
    if @video_attrs.save
      #redirect_to course_tut_path(@tut.course, @tut, params[:blob_id])
      redirect_to request.referrer
      flash[:notice] = "Title Changed!"
    end
  end

  def edit_filename
    @blob_id = params[:blob_id]
  end

  def remove_video
    if @tut.videos.find_by(blob_id: params[:blob_id]).purge_later
      #redirect_to edit_course_tut_path(@tut.course)
      redirect_to request.referrer
      flash.now[:notice] = "Video Deleted!"
    end
  end

  # GET Request
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

  # GET Request
  def new
    @tut = @course.tuts.build
  end

  # POST Request
  def create
    @tut = @course.tuts.build(tut_params)
    if @tut.save
      redirect_to course_tuts_path(@course)
      flash[:notice] = "Video Uploaded!"
    else 
      render :new
    end
  end

  # GET Request
  def edit; end

  # PATCH Request
  def update
    @tut = Tut.find(params[:id])
    if @tut.update(tut_params)
      redirect_to course_tuts_path(@course)
    end
  
  end

 # PATCH Request which dynamically changes the position of the video while sorting (Admin feature)
  def update_position
    @tut = Tut.find(params[:id])
    @tut.insert_at(tut_params[:position].to_i)
    head :ok
  end

  # DELETE Request
  def destroy
    if @tut.destroy
      redirect_to course_tuts_path(@course), notice: "Video Deleted!"
    end
  end

  private
    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_tut
      @tut = Tut.find(params[:id])
    end

    # Permitting the form details into database
    def tut_params
      params.require(:tut).permit(:course_id, :title, :position, :video, videos: [] )
    end
end