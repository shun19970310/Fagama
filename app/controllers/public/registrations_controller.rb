
class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_guest, only: %i[update destroy]
  def check_guest
   if resource.email == 'guest@example.com'
     redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません。'
   end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email])
  end
end
