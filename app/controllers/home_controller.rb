class HomeController < ApplicationController
  def index
    redirect_to new_user_session_path if !current_user

    @all_sites = Site.all.order(:name).limit(5)

    tags = Site.tag_counts_on(:regions).most_used(5)
    @most_popular_tags = {}
    tags.each do |tag|
      @most_popular_tags[tag.name] = Site.tagged_with(tag.name).order(:name).limit(5)
    end

    activities = PublicActivity::Activity.all.order('created_at desc')
    @activities = activities.paginate(page: params[:page], per_page: 20)
    
  end
end
