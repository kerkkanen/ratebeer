class RatingsController < ApplicationController
  PAGE_SIZE = 3

  def index
    @breweries = Brewery.top(3)
    @beers = Beer.top(3)
    @styles = Style.top(3)
    @users = User.top(3)

    @order = params[:order] || 'newest'
    @page = params[:page]&.to_i || 1
    @last_page = (Rating.count.to_f / PAGE_SIZE).ceil
    offset = (@page - 1) * PAGE_SIZE

    @ratings = case @order
               when "newest" then Rating.includes(:user).order(created_at: :desc)
                                        .limit(PAGE_SIZE).offset(offset)
               when "oldest" then Rating.includes(:user).order(created_at: :asc)
                                        .limit(PAGE_SIZE).offset(offset)
               end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def show
    @rating = Rating.includes(beer: :brewery).find(params[:id])
    return unless turbo_frame_request?

    render partial: 'details', locals: { rating: @rating, brewery: @rating.beer.brewery }
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    destroy_ids = request.body.string.split(',')
    destroy_ids.each do |id|
      rating = Rating.find_by(id:)
      rating.destroy if rating && current_user == rating.user
      # Rescue in case one of the rating IDs is invalid so we can continue deleting the rest
    rescue StandardError => e
      puts "Rating record has an error: #{e.message}"
    end
    @user = current_user
    respond_to do |format|
      format.html { render partial: '/users/ratings', status: :ok, user: @user }
    end
  end
end
