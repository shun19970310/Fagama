class Public::LikesController < ApplicationController
 before_action :authenticate_customer!

  def create
   @post = Post.find(params[:post_id])
   like = current_customer.likes.new(post_id: @post.id)
   like.save
  end

  def destroy
   @post = Post.find(params[:post_id])
   like = current_customer.likes.find_by(post_id: @post.id)
   like.destroy
  end
end
