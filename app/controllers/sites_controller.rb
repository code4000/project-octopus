class SitesController < ApplicationController
  load_and_authorize_resource class: Site, except: [:create]
  def index
    @sites = filtered_sites
  end

  def show
    @site = Site.find_by_id(params[:id])
    @activities = get_site_activities.paginate(page: params[:page], per_page: 20)
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
    @site.comments.destroy_all
    @site.destroy
    flash[:notice] = "Successfully deleted."
    redirect_to sites_path
  end

  def search
    redirect_to sites_path(request.params)
  end

  private

  def site_params
    params.permit(site: [
                        :name,
                        :capacity,
                        :manager,
                        :contact_number,
                        :gender,
                        {:region_list => []},
                        {:tag_list => []}
                        ])[:site]
  end

  def filtered_sites
    results = Site.all

    results = results.where("name ILIKE ?", "%#{params.dig(:name)}") if params&.dig(:name).present?

    results = results.tagged_with(params.dig(:region_list), :on => :regions, :any => true) if params&.dig(:region_list).present?

    results = results.where(gender: params.dig(:gender)) if params&.dig(:gender).present?

    results = results.tagged_with(params.dig(:tag_list), :on => :tags, :any => true) if params&.dig(:tag_list).present?

    results.order(:name)
  end

  def get_site_activities
    (@site.activities +
        (PublicActivity::Activity.preload(:trackable).where(trackable_type: "Student").select{ |activity| activity&.trackable&.site&.id == @site.id }) +
          (PublicActivity::Activity.preload(:trackable).where(trackable_type: "Comment").select { |activity| activity&.trackable&.resource_type == "Site" && activity&.trackable&.resource_id == @site.id }) +
            (PublicActivity::Activity.preload(:trackable).where(trackable_type: "Comment").select { |activity| activity&.trackable&.resource_type == "Student" && activity&.trackable&.resource&.site&.id == @site.id }))
              .sort_by(&:created_at).reverse
  end
end
