class Public::CommentsController < ApplicationController
  before_action :authenticate_customer!

  def create
    post = Post.find(params[:post_id])
    comment = current_customer.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
      @comments = post.comments.page(params[:page]).per(10).reverse_order
      flash.now[:notice] = 'コメントを投稿しました'
      render "public/posts/post_comment"
    else
      redirect_to post_path(params[:post_id]), alert: 'コメントを入力して下さい'
    end
  end

  def destroy
    Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    flash.now[:alert] = '投稿を削除しました'
    @post = Post.find(params[:post_id])
    render "public/posts/post_comment"
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :customer_id)
  end
end
