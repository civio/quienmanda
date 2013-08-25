class SearchController < ApplicationController
  def search
    @query = params[:q]

    @results = PgSearch.multisearch(@query).page(params[:page]).per(15)
  end
end
