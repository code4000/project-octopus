class ContactsController < ApplicationController
  load_and_authorize_resource class: Contact, except: [:create]

  def index
    @contacts = Contact.all.order(:first_name)
  end

  def show
    @contact = Contact.find_by_id(params[:id])
  end

  def edit
    @contact = Contact.find_by_id(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:notice] = 'contact updated successfully'
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
      flash[:notice] = 'contact added!'
      redirect_to contact_path(@contact)
    else
      flash[:alert] = "Error: #{@contact.errors.full_messages.to_sentence}"
      render 'new'
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.contact_comments.destroy_all
    @contact.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to contacts_path
  end

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
                        {:tag_list => []}
                        ])[:contact]
  end
end
