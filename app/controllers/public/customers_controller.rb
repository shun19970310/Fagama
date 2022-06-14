class Public::CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :unsubscribe, :likes, :withdraw]
  before_action :authenticate_customer!, except: [:guest_sign_in]

  def show
    @posts = @customer.posts.page(params[:page]).per(10)
    # 退会済みユーザーを除くフォロー/フォロワーリスト
    @followings_count_all = @customer.alive_followings.count
    @followers_count_all = @customer.alive_followers.count
  end

  def edit
  end

  def update
    @customer.update(customer_params)
    redirect_to customer_path(@customer)
  end

  def unsubscribe
    if current_customer.name == "guestuser"
      redirect_to customer_path(current_customer)
    end
  end

  def withdraw
    @customer.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "退会が完了しました"
  end

  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to posts_path, notice: "ゲストログインしました"
  end

  def likes
    likes = Like.where(customer_id: @customer.id).pluck(:post_id)
    @like_posts = Post.find(likes)
  end

  def followings
    customer = Customer.find(params[:id])
    @customers = customer.alive_followings
  end

  def followers
    customer = Customer.find(params[:id])
    @customers = customer.alive_followers
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :introduction, :image)
  end
end