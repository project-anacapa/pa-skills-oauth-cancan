class ExercisesController < ApplicationController
  load_and_authorize_resource

  before_action :set_exercise, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @exercises = Exercise.all
    respond_with(@exercises)
  end

  def show
    respond_with(@exercise)
  end

  def new
    @exercise = Exercise.new
    respond_with(@exercise)
  end

  def edit
  end

  def create
    @exercise = Exercise.new(exercise_params)
    @exercise.save
    respond_with(@exercise)
  end

  def update
    @exercise.update(exercise_params)
    respond_with(@exercise)
  end

  def destroy
    @exercise.destroy
    respond_with(@exercise)
  end

  private
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    def exercise_params
      params.require(:exercise).permit(:title, :content)
    end
end
