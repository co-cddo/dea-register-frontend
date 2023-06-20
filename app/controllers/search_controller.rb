class SearchController < ApplicationController
  def index
    redirect_to(root_path, alert: "Please enter text into your search") if params[:q].blank?

    search = PgSearch.multisearch(params[:q]).includes(:searchable)

    @pagy, @search = pagy(search)
  end
end
