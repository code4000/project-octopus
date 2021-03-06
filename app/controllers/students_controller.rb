class StudentsController < ApplicationController
  load_and_authorize_resource class: Student, except: [:create]

  def index
    @students = filtered_students
  end

  def show
    @student = Student.find_by_id(params[:id])
    @activities = get_student_activities.paginate(page: params[:page], per_page: 20)
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

  def import
    redirection_path = import_students_path

    if params.dig(:file)&.content_type == "text/csv"
      @importer = StudentImporter.new(params.dig(:file)&.path)
      if @importer.save
        redirection_path = students_path
      else
        flash[:alert] = "Error: #{@importer.errors.full_messages.to_sentence}"
      end
      flash[:notice] = "#{@importer.items.length} students added/updated!" if @importer.items.present?
    else
      flash[:alert] = "Please select a valid .CSV file."
    end
    redirect_to redirection_path
  end

  def importer
    @importer_class = StudentImporter
  end

  private

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

    # results = results.where(dob: params.dig(:dob)) if params&.dig(:dob).present?

    results = results.where("dob >= ?", params.dig(:dob_from)) if params&.dig(:dob_from).present?

    results = results.where("dob <= ?", params.dig(:dob_to)) if params&.dig(:dob_to).present?

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

    sort_by = "first_name"
    sort_by = sort_results unless params&.dig(:sort_by).nil?

    sort_order = "asc"
    sort_order = order_results unless params&.dig(:order).nil?

    results.order("#{sort_by} #{sort_order}")
  end

  def sort_results
    case params&.dig(:sort_by)
    when "First name"
      sort_by = "first_name"
    when "Last name"
      sort_by = "last_name"
    when "Date of birth"
      sort_by = "dob"
    when "Release date"
      sort_by = "crd"
    when "Tag date"
      sort_by = "hdc"
    when "ROTL date"
      sort_by = "rotl"
    when "Recategorisation date"
      sort_by = "recat"
    end
    sort_by
  end

  def order_results
    case params&.dig(:order)
    when "Ascending"
      sort_order = "asc"
    when "Descending"
      sort_order = "desc"
    end
    sort_order
  end

  def get_student_activities
    (@student.activities +
      (PublicActivity::Activity.preload(:trackable).where(trackable_type: "Comment").select { |activity| activity&.trackable&.resource_type == "Student" && activity&.trackable&.resource&.id == @student.id }))
        .sort_by(&:created_at).reverse
  end
end
