class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:view] ||= 0
    session[:view] += 1

    if session[:view] <= 3
      article = Article.find(params[:id])
      render json: article
    else
      render json: { error: 'Maximum articles viewed'}, status: 401
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
