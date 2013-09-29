class SearchController < ApplicationController
  def search
    @query = params[:q]
    @title = "Resultados para #{@query}"
    @results = PgSearch.multisearch(@query).page(params[:page]).per(15)
  end
end
