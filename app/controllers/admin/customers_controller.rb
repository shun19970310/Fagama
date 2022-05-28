class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_customer, only: [:show, :edit]

  def index
    @customers = Customer.page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

  def update
    customer = Customer.find(params[:id])
    if customer.update(customer_params)
      redirect_to admin_customer_path(customer), notice: "会員情報を更新しました"
    else
      redirect_to edit_admin_customer_path(customer), alert: "更新に失敗しました"
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :introduction, :is_deleted)
  end
end
