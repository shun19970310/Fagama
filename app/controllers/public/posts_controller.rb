class Public::PostsController < ApplicationController
  before_action :authenticate_customer!, except: [:index]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    tag_list=params[:post][:name].split(',')
    if @post.save
      @post.save_tag(tag_list)
      redirect_to posts_path, notice: "投稿に成功しました"
    else
      @posts = Post.all
       render :index
    end
  end

  def index
    @posts = Post.all.includes(:customer).order(created_at: :desc).page(params[:page])
    @tag_list=Tag.all
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list=@post.tags.pluck(:name).join(',')
    if @post.customer != current_customer
      redirect_to posts_path, alert:'不正なアクセスです'
    end
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post), notice: "更新に成功しました"
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: "削除に成功しました"
  end

  def ensure_correct_user
    @post = Post.find_by(id:params[:id])
    if @post.customer_id != @current_customer.id
      flash[:notice] = "権限がありません"
      redirect_to posts_path
    end
  end

   def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.page(params[:page]).per(10)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category, :customer_id)
  end
end
