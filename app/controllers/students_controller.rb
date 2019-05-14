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

  def add_skills
    @student = Student.find(params[:student])

    if params.dig(:tags).present?
      params.dig(:tags).each do |tag|
        @student.skill_list.add(tag) unless @student.skill_list.include?(tag)
      end
    end

    @student.skill_list.each do |tag|
      @student.skill_list.remove(tag) unless params.dig(:tags).include?(tag)
    end

    @student.save
  end

  def add_job_preferences
    @student = Student.find(params[:student])

    if params.dig(:tags).present?
      params.dig(:tags).each do |tag|
        @student.job_preference_list.add(tag) unless @student.job_preference_list.include?(tag)
      end
    end

    @student.job_preference_list.each do |tag|
      @student.job_preference_list.remove(tag) unless params.dig(:tags).include?(tag)
    end

    @student.save
  end

  def add_tags
    @student = Student.find(params[:student])

    if params.dig(:tags).present?
      params.dig(:tags).each do |tag|
        @student.tag_list.add(tag) unless @student.tag_list.include?(tag)
      end
    end

    @student.tag_list.each do |tag|
      @student.tag_list.remove(tag) unless params.dig(:tags).include?(tag)
    end

    @student.save
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
                        :skill_list,
                        :job_preference_list,
                        :tag_list,
                        :notes
                        ])[:student]
  end
end
