class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = Comment.all.includes(:customer).order(created_at: :desc).page(params[:page]).per(10)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to request.referer, alert: 'コメントを削除しました'
  end
end
