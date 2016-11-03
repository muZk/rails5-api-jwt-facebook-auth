class UsersController < ApplicationController

  before_action :authenticate_user

  def profile
    render json: current_user
  end

end
