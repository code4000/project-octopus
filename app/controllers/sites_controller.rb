class SitesController < ApplicationController
  def index
    @sites = Site.all
  end

  def show
    @site = Site.find_by_id(params[:id])
  end
end
