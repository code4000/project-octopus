class SitesController < ApplicationController
  load_and_authorize_resource class: Site, except: [:create]
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

  def destroy
    @site = Site.find(params[:id])
    @site.students.each do |student|
      student.site = nil
      student.save
    end
    @site.destroy
    flash[:notice] = "Successfully deleted."
    redirect_back fallback_location: sites_path
  end

  def site_params
    params.permit(site: [
                        :name,
                        :capacity,
                        :manager,
                        :contact_number,
                        :gender,
                        :region_list,
                        :tag_list,
                        :notes
                        ])[:site]
  end
end
