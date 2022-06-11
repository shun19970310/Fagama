class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.all.includes(:customer).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_posts_path, notice: "削除に成功しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category).merge(customer_id: current_customer.id)
  end
end
