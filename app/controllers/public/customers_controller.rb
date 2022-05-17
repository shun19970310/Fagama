class Public::CustomersController < ApplicationController
  before_action :set_customer, only: [:likes]

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page])
    @like_posts = @customer.like_posts.page(params[:page])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to customer_path(@customer)
  end

  def unsubscribe
    if current_customer.name == "guestuser"
      redirect_to customer_path(current_customer)
    end
  end

  def withdraw
    current_customer.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "退会が完了しました"
  end

  def likes
    likes = Like.where(customer_id: @customer.id).pluck(:post_id)
    @like_posts = Post.find(likes)
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :introduction, :image)
  end
end