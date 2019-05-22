class CommentsController < ApplicationController

  def contact_comment_create
    @contact = Contact.find(params[:contact_id])
    @comment = @contact.comments.new(user: current_user)
    if @comment.update_attributes(comment_params)
      flash[:notice] = "Comment added."
    else
      flash[:alert] = "Error: #{@comment.errors.full_messages.to_sentence}"
    end
    redirect_to contact_path(@contact)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to request.referer
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
