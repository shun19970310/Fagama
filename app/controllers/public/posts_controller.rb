class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params,customer_id: @current_customer.id)
    if @post.save
      redirect_to posts_path, notice: "投稿に成功しました"
    else
      render :new
    end
  end

  def index
    @posts = Post.all
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
    params.require(:post).permit(:title, :body, :category)
  end
end
