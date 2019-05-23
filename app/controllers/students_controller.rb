class StudentsController < ApplicationController
  load_and_authorize_resource class: Student, except: [:create]

  def index
    @students = filtered_students
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
    @student.comments.destroy_all
    @student.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to students_path
  end

  def search
    redirect_to students_path(request.params)
  end

  def student_params
    params.permit(student: [
                        :first_name,
                        :last_name,
                        :prison_number,
                        :site_id,
                        :gender,
                        :dob,
                        :contact_number,
                        :email,
                        :crd,
                        :hdc,
                        :rotl,
                        :recat,
                        {:skill_list => []},
                        {:job_preference_list => []},
                        {:tag_list => []}
                        ])[:student]
  end

  def filtered_students
    results = Student.all

    results = results.where("first_name ILIKE ?", "%#{params.dig(:first_name)}") if params&.dig(:first_name).present?

    results = results.where("last_name ILIKE ?", "%#{params.dig(:last_name)}") if params&.dig(:last_name).present?

    results = results.where("prison_number ILIKE ?", "%#{params.dig(:prison_number)}") if params&.dig(:prison_number).present?

    if params&.dig(:site).present?
      if params.dig(:site) == "Non listed"
        results = results.left_outer_joins(:site).where( sites: { id: nil } )
      else
        results = results.joins(:site).where(sites: { name: params.dig(:site) } )
      end
    end

    results = results.where(gender: params.dig(:gender)) if params&.dig(:gender).present?

    results = results.where(dob: params.dig(:dob)) if params&.dig(:dob).present?

    results = results.where("crd < ? OR hdc < ?", Date.today, Date.today) if params&.dig(:released?) == "1"

    results = results.where("crd >= ?", params.dig(:crd_from)) if params&.dig(:crd_from).present?

    results = results.where("crd <= ?", params.dig(:crd_to)) if params&.dig(:crd_to).present?

    results = results.where("hdc >= ?", params.dig(:hdc_from)) if params&.dig(:hdc_from).present?

    results = results.where("hdc <= ?", params.dig(:hdc_to)) if params&.dig(:hdc_to).present?

    results = results.where("rotl >= ?", params.dig(:rotl_from)) if params&.dig(:rotl_from).present?

    results = results.where("rotl <= ?", params.dig(:rotl_to)) if params&.dig(:rotl_to).present?

    results = results.where("recat >= ?", params.dig(:recat_from)) if params&.dig(:recat_from).present?

    results = results.where("recat <= ?", params.dig(:recat_to)) if params&.dig(:recat_to).present?

    results = results.tagged_with(params.dig(:skill_list), :on => :skills, :any => true) if params&.dig(:skill_list).present?

    results = results.tagged_with(params.dig(:job_preference_list), :on => :job_preferences, :any => true) if params&.dig(:job_preference_list).present?

    results = results.tagged_with(params.dig(:tag_list), :on => :tags, :any => true) if params&.dig(:tag_list).present?

    results.order(:first_name)
  end
end
