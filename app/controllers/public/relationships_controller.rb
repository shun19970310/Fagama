class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!

  def create
    following = current_customer.relationships.build(follower_id: params[:customer_id])
    following.save
    redirect_to request.referrer
  end

  def destroy
    following = current_customer.relationships.build(follower_id: params[:customer_id])
    following.destroy
    redirect_to request.referrer
  end
end
