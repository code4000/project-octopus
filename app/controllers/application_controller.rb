class ApplicationController < ActionController::Base
  require 'will_paginate/array'
  include PublicActivity::StoreController

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "You do not have permission to access this page"
    redirect_back fallback_location: root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
