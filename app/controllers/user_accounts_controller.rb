class UsersController < ApplicationController
  load_and_authorize_resource class: User, except: [:create]
  def index
    @users = User.all
  end
end
