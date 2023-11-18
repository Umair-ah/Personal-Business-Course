require 'stripe'
Stripe.api_key = "sk_test_51NcIGEJdM2t98eyhyW2R6HDffCWMy4msgF16bpW3Mi20ihKOgpoPItOne2lVDSmqxUDZ4ehVJLnqAYErZvimN46h00fYFnRiOL"

class CoursesController < ApplicationController
  before_action :set_course, only: %i[edit update destroy]
  before_action :authenticate_user!, except: %i[index]

  def index
    @q = Course.ransack(params[:q])
    @courses = @q.result.order(created_at: :desc)
  end

  def new
    @course = current_user.courses.build
  end

  def create
    @course = current_user.courses.build(course_params)
    if @course.save
      redirect_to courses_path
      flash[:notice] = "New Course added!"
    else
      render :new
    end
  end

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