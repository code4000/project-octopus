class ContactsController < ApplicationController
  load_and_authorize_resource class: Contact, except: [:create]

  def index
    @contacts = filtered_contacts
  end

  def show
    @contact = Contact.find_by_id(params[:id])
    @activities = get_contact_activities.paginate(page: params[:page], per_page: 20)
  end

  def edit
    @contact = Contact.find_by_id(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:notice] = 'Contact updated successfully'
      redirect_to contact_path(@contact)
    else
      flash[:alert] = "Error: #{@contact.errors.full_messages.to_sentence}"
      render 'edit'
    end
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:notice] = 'Contact added!'
      redirect_to contact_path(@contact)
    else
      flash[:alert] = "Error: #{@contact.errors.full_messages.to_sentence}"
      render 'new'
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.comments.destroy_all
    @contact.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to contacts_path
  end

  def search
    redirect_to contacts_path(request.params)
  end

  def import
    redirection_path = import_contacts_path

    if params.dig(:file)&.content_type == "text/csv"
      @importer = ContactImporter.new(params.dig(:file)&.path)
      if @importer.save
        redirection_path = contacts_path
      else
        flash[:alert] = "Error: #{@importer.errors.full_messages.to_sentence}"
      end
      flash[:notice] = "#{@importer.items.length} contacts added/updated!" if @importer.items.present?
    else
      flash[:alert] = "Please select a valid .CSV file."
    end
    redirect_to redirection_path
  end

  def importer
    @importer_class = ContactImporter
  end

  private

  def contact_params
    params.permit(contact: [
                        :first_name,
                        :last_name,
                        :role,
                        :organisation,
                        :email,
                        :mobile_number,
                        :work_number,
                        :about,
                        :role,
                        {:tag_list => []}
                        ])[:contact]
  end

  def filtered_contacts
    results = Contact.all

    results = results.where("first_name ILIKE ?", "%#{params.dig(:first_name)}") if params&.dig(:first_name).present?

    results = results.where("last_name ILIKE ?", "%#{params.dig(:last_name)}") if params&.dig(:last_name).present?

    results = results.where("organisation ILIKE ?", "%#{params.dig(:organisation)}") if params&.dig(:organisation).present?

    results = results.where("role ILIKE ?", "%#{params.dig(:role)}") if params&.dig(:role).present?

    results = results.tagged_with(params.dig(:tag_list), :on => :tags, :any => true) if params&.dig(:tag_list).present?

    results.order(:first_name)
  end

  def get_contact_activities
    (@contact.activities +
      (PublicActivity::Activity.preload(:trackable).where(trackable_type: "Comment").select { |activity| activity&.trackable&.resource_type == "Contact" && activity&.trackable&.resource&.id == @contact.id }))
        .sort_by(&:created_at).reverse
  end
end
