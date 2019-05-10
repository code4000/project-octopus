class UserAccountsController < ApplicationController
  load_and_authorize_resource class: User, except: [:create]
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = 'User updated successfully'
      redirect_to user_accounts_path
    else
      flash[:alert] = "Error: #{@user.errors.full_messages.to_sentence}"
      render 'edit'
    end
  end

  def new
    @user = User.new
  end

  def create
    require 'securerandom'
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(8)
    if @user.save
      # TODO: email user password
      UserMailer.with(user: @user).welcome_email.deliver_now
      flash[:notice] = 'Account added!'
      redirect_to user_accounts_path
    else
      flash[:alert] = "Error: #{@user.errors.full_messages.to_sentence}"
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to user_accounts_path
  end

  def user_params
    params.permit(user: [
                        :name,
                        :email,
                        :role,
                        ])[:user]
  end
end
