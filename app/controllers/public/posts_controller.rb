class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end
  def create
    @post = Post.new(post_params)
    if @post.save!
      redirect_to posts_path, notice: "投稿に成功しました"
    else
      @posts = Post.all
       render :index
    end
  end

  def index
    @post = Post.new
    @newpost = Post.new
    @posts = Post.all.includes(:customer).order(created_at: :desc).page(params[:page])

  end

  def show
    @post = Post.find_by(id: params[:id])
    @customer = Customer.find_by(id: @post.customer_id)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def ensure_correct_user
    @post = Post.find_by(id:params[:id])
    if @post.customer_id != @current_customer.id
      flash[:notice] = "権限がありません"
      redirect_to posts_path
    end
  end
  private
  def post_params
    params.require(:post).permit(:title, :body, :category, :customer_id)
  end
end
