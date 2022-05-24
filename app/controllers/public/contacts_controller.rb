class Public::ContactsController < ApplicationController
  before_action :authenticate_customer!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact, current_customer).deliver
      redirect_to root_path, notice: 'お問い合わせ内容を送信しました'
    else
      redirect_to new_contact_path(customer_id: current_customer.id ), alert: 'お名前とお問い合わせ内容を記載して下さい'
    end
  end


  private

  def contact_params
    params.require(:contact).permit(:name, :content)
  end
end
