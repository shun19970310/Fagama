class Public::GroupsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update]
  before_action :set_group, only: [:join, :new_mail, :send_mail]

  def new
    @group = Group.new
  end

  def index
    @groups = Group.page(params[:page]).per(10)
  end

  def show
    @post = Post.new
    @group = Group.find(params[:id])
  end

  def join
    @group.customers << current_customer
    redirect_to  groups_path, notice: '参加に成功しました'
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_customer.id
    @group.customers << current_customer
    if @group.save
      redirect_to groups_path, notice: 'グループを作成しました'
    else
      redirect_to new_group_path, alert: 'グループ名及び紹介文を入力して下さい'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: 'グループを更新しました'
    else
      redirect_to edit_group_path(@group), alert: 'グループの更新に失敗しました'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.customers.delete(current_customer)
    redirect_to groups_path, notice: 'グループを削除しました。'
  end

  def new_mail
  end

  def send_mail
    group_customers = @group.customers
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title, @mail_content,group_customers).deliver
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def ensure_correct_customer
    @group = Group.find(params[:id])
    unless @group.owner_id == current_customer.id
      redirect_to groups_path
    end
  end
end
