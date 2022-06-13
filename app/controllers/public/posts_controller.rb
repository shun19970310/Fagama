class Public::PostsController < ApplicationController
  before_action :authenticate_customer!, except: [:index]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

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
      redirect_to new_post_path, alert: 'タイトル及び投稿内容を入力して下さい'
    end
  end

  def index
    if params[:new]
      @posts = Post.latest.includes(:customer).where(customer: {is_deleted: false}).page(params[:page]).per(10)
    elsif params[:old]
      @posts = Post.old.includes(:customer).where(customer: {is_deleted: false}).page(params[:page]).per(10)
    elsif params[:like_count]
      @posts = Post.like_count.includes(:customer).where(customer: {is_deleted: false}).page(params[:page]).per(10)
    elsif params[:comment_count]
      @posts = Post.comment_count.includes(:customer).where(customer: {is_deleted: false}).page(params[:page]).per(10)
    else
      @posts = Post.all.includes(:customer).where(customer: {is_deleted: false}).order(created_at: :desc).page(params[:page]).per(10)
      # @posts = Post.left_joins(:customer).where(customer: {is_deleted: false}).order(created_at: :desc).page(params[:page]).per(10)
    end
    @tag_list=Tag.all
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
    @commets_count_all = @post.comments.count
    @comments = @post.comments.page(params[:page]).per(10).reverse_order
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
      redirect_to edit_post_path(@post), alert: '更新に失敗しました'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: "削除に成功しました"
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.customer_id != current_customer.id
      redirect_to posts_path, alert: "権限がありません"
    end
  end

  def search
    @posts = Post.search(params[:keyword])
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.page(params[:page]).per(10)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category).merge(customer_id: current_customer.id)
  end
end
