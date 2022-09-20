class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    session[:last_rating] = "#{@rating.beer.name} #{@rating.score} points"
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    orphan = Rating.all.select{|rating| rating.user.nil? || rating.beer.nil?}
    orphan.each{|rating| rating.destroy}
    redirect_to ratings_path
  end
end
