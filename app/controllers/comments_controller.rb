class CommentsController < ApplicationController

  def create
    @resource = find_resource
    @comment = @resource.comments.new(user: current_user)
    if @comment.update_attributes(comment_params)
      flash[:notice] = "Comment added."
    else
      flash[:alert] = "Error: #{@comment.errors.full_messages.to_sentence}"
    end
    redirect_to request.referer
  end

  def find_resource
    resource = Student.find(params[:student_id]) if params[:student_id]
    resource = Contact.find(params[:contact_id]) if params[:contact_id]
    resource
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
