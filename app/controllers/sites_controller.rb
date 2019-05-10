class SitesController < ApplicationController
  def index
    @sites = Site.all
  end

  def show
    @site = Site.find_by_id(params[:id])
  end

  def edit
    @site = Site.find_by_id(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    if @site.update_attributes(site_params)
      flash[:notice] = 'Site updated successfully'
      redirect_to site_path(@site)
    else
      flash[:alert] = "Error: #{@site.errors.full_messages.to_sentence}"
      render 'edit'
    end
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      flash[:notice] = 'Site added!'
      redirect_to site_path(@site)
    else
      flash[:alert] = "Error: #{@site.errors.full_messages.to_sentence}"
      render 'new'
    end
  end

  def site_params
    params.permit(site: [
                        :name,
                        :capacity,
                        :region,
                        :manager,
                        :notes
                        ])[:site]
  end
end
