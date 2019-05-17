class ArticlesController < ApplicationController
  load_and_authorize_resource class: Article, except: [:create]

  def index
    @articles = Article.all.order(:published_at)
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.find_by_id(params[:id])
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = 'Article added!'
      redirect_to article_path(@article)
    else
      flash[:alert] = "Error: #{@article.errors.full_messages.to_sentence}"
      render 'new'
    end
  end

  def edit
    @article = Article.find_by_id(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(article_params)
      flash[:notice] = 'article updated successfully'
      redirect_to article_path(@article)
    else
      flash[:alert] = "Error: #{@article.errors.full_messages.to_sentence}"
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to articles_path
  end

  def article_params
    params.permit(article: [
                        :title,
                        :content,
                        :publish,
                        :published_at
                        ])[:article]
  end
end
