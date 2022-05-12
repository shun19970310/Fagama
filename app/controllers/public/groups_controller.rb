class Public::GroupsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update]

  def index
    @post = Post.new
    @groups = Group.all
  end

  def show
    @post = Post.new
    @group = Group.find(params[:id])
  end

  def join
    @group = Group.find(params[:group_id])
    @group.customers << current_customer
    redirect_to  groups_path
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_customer.id
    @group.customers << current_customer
    if @group.save
      redirect_to groups_path, notice: 'グループを作成しました。'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: 'グループを更新しました。'
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.customers.delete(current_customer)
    redirect_to groups_path, notice: 'グループを削除しました。'
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_customer
    @group = Group.find(params[:id])
    unless @group.owner_id == current_customer.id
      redirect_to groups_path
    end
  end
end
