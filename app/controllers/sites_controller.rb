class SitesController < ApplicationController
  load_and_authorize_resource class: Site, except: [:create]
  def index
    @sites = filtered_sites
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
    redirect_to sites_path
  end

  def search
    redirect_to sites_path(request.params)
  end

  def site_params
    params.permit(site: [
                        :name,
                        :capacity,
                        :manager,
                        :contact_number,
                        :gender,
                        {:region_list => []},
                        {:tag_list => []},
                        :notes
                        ])[:site]
  end

  def filtered_sites
    results = Site.all

    results = results.where("name ILIKE ?", "%#{params.dig(:name)}") if params&.dig(:name).present?

    results = results.tagged_with(params.dig(:region_list), :on => :regions, :any => true) if params&.dig(:region_list).present?

    results = results.where(gender: params.dig(:gender)) if params&.dig(:gender).present?

    results = results.tagged_with(params.dig(:tag_list), :on => :tags, :any => true) if params&.dig(:tag_list).present?

    results
  end

  # def add_regions
  #   @site = Site.find(params[:site])
  #
  #   if params.dig(:tags).present?
  #     params.dig(:tags).each do |tag|
  #       @site.region_list.add(tag) unless @site.region_list.include?(tag)
  #     end
  #   end
  #
  #   @site.region_list.each do |tag|
  #     @site.region_list.remove(tag) unless params.dig(:tags).include?(tag)
  #   end
  #
  #   @site.save
  # end
  #
  # def add_tags
  #   @site = Site.find(params[:site])
  #
  #   if params.dig(:tags).present?
  #     params.dig(:tags).each do |tag|
  #       @site.tag_list.add(tag) unless @site.tag_list.include?(tag)
  #     end
  #   end
  #
  #   @site.tag_list.each do |tag|
  #     @site.tag_list.remove(tag) unless params.dig(:tags).include?(tag)
  #   end
  #
  #   @site.save
  # end
end
