class ContactCommentsController < ApplicationController

  def create
    @contact = Contact.find(params[:contact_id])
    @comment = @contact.contact_comments.new(user_id: current_user.id)
    if @comment.update_attributes(comment_params)
      flash[:notice] = "Comment added."
    else
      flash[:alert] = "Error: #{@comment.errors.full_messages.to_sentence}"
    end
    redirect_to contact_path(@contact)
  end

  def destroy
    @contact = Contact.find(params[:contact_id])
    @comment = @contact.contact_comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to contact_path(@contact)
  end

  private
    def comment_params
      params.require(:contact_comment).permit(:body)
    end
end
