class Public::LikesController < ApplicationController
 before_action :authenticate_customer!
 before_action :set_post, only: [:create, :destroy]

  def create
   like = current_customer.likes.new(post_id: @post.id)
   like.save
  end

  def destroy
   like = current_customer.likes.find_by(post_id: @post.id)
   like.destroy
  end

  private

  def set_post
   @post = Post.find(params[:post_id])
  end
end
