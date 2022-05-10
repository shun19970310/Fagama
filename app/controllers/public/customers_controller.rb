class Public::CustomersController < ApplicationController
  private

  def list_params
    params.require(:user).permit(:name, :email, :image)
　end
