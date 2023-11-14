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

 