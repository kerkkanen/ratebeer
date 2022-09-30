class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:search_city] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end

  def show
    searched = Rails.cache.read session[:search_city]
    puts "moi"
    puts params[:id]
    puts "moi"
    @place
  end
end