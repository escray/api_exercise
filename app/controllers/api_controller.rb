#
class ApiController < ActionController::Base
  before_action :authentication_user_from_token!

  def authentication_user_from_token!
    if params[:auth_token].present?
      user = User.find_by_authentication_token(params[:auth_token])
      sign_in(user, store: false) if user
    end
  end
end
