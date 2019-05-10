class StudentsController < ApplicationController
  load_and_authorize_resource class: Student, except: [:create]

  def index
    @students = Student.all
  end

  def show
    @student = Student.find_by_id(params[:id])
  end

  def edit
    @student = Student.find_by_id(params[:id])
  end

  def update
    @student = Student.find_by_id(params[:id])
    if @student.update_attributes(student_params)
      flash[:notice] = 'Student updated successfully'
      redirect_to student_path(@student)
    else
      flash[:alert] = "Error: #{@student.errors.full_messages.to_sentence}"
      render 'edit'
    end
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      flash[:notice] = 'Student added!'
      redirect_to student_path(@student)
    else
      flash[:alert] = "Error: #{@student.errors.full_messages.to_sentence}"
      render 'new'
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    flash[:notice] = "Successfully deleted."
    redirect_back fallback_location: students_path
  end

  def student_params
    params.permit(student: [
                        :first_name,
                        :last_name,
                        :prison_number,
                        :site_id,
                        :gender,
                        :dob,
                        :crd,
                        :hdc,
                        :rotl,
                        :recat,
                        :notes
                        ])[:student]
  end
end
