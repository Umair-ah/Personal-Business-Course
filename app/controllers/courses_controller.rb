require 'stripe'
Stripe.api_key = "sk_test_51NcIGEJdM2t98eyhyW2R6HDffCWMy4msgF16bpW3Mi20ihKOgpoPItOne2lVDSmqxUDZ4ehVJLnqAYErZvimN46h00fYFnRiOL"

class CoursesController < ApplicationController
  # These methods are called at the start of every REQUEST (i.e POST, GET, PATCH, DELETE)
  before_action :set_course, only: %i[edit update destroy remove_thumbnail]
  before_action :authenticate_user!, except: %i[index]

  # remove attachment
  def remove_thumbnail
    @image = ActiveStorage::Attachment.find_by(record_id: params[:id], record_type: "Course")
    @image.purge_later
    redirect_back(fallback_location: request.referer)
  end

  # GET Request 
  def index
    @q = Course.ransack(params[:q])
    @courses = @q.result.order(created_at: :desc)
  end

  # GET Request
  def new
    @course = current_user.courses.build
  end

  # POST Request
  def create
    @course = current_user.courses.build(course_params)
    if @course.save
      redirect_to courses_path
      flash[:notice] = "New Course added!"
    else
      render :new
    end
  end
 # GET Request
  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to courses_path
      flash[:notice] = "Course Updated!"
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.destroy
      redirect_to courses_path
      flash[:alert] = "Course '#{@course.title}' Deleted!"
    end
  end


  private
    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description, :price, :user_id, :thumbnail)
    end


end