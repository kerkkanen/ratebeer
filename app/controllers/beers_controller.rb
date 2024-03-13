class BeersController < ApplicationController
  before_action :set_beer, only: %i[show edit update destroy]
  before_action :set_breweries_and_styles_for_template, only: [:new, :edit, :create]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]

  PAGE_SIZE = 5

  def index
    @order = params[:order] || 'name'
    @page = params[:page]&.to_i || 1
    @last_page = (Beer.count.to_f / PAGE_SIZE).ceil
    offset = (@page - 1) * PAGE_SIZE

    @beers = case @order
             when "name" then Beer.order(:name)
                                  .limit(PAGE_SIZE).offset(offset)
             when "brewery" then Beer.joins(:brewery)
                                     .order("breweries.name").limit(PAGE_SIZE).offset(offset)
             when "style" then Beer.joins(:style)
                                   .order("styles.name").limit(PAGE_SIZE).offset(offset)
             when "rating" then Beer.left_joins(:ratings)
                                    .select("beers.*, avg(ratings.score)")
                                    .group("beers.id")
                                    .order("avg(ratings.score) DESC").limit(PAGE_SIZE).offset(offset)
             end

    if turbo_frame_request?
      render partial: "beer_list",
             locals: { beers: @beers, page: @page, order: @order, last_page: @last_page }
    else
      render :index
    end
  end

  def list
  end

  def set_breweries_and_styles_for_template
    @breweries = Brewery.all
    @styles = Style.all
  end

  # GET /beers/1 or /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
  end

  # GET /beers/1/edit
  def edit
  end

  # POST /beers or /beers.json
  def create
    %w(beerlist-name beerlist-brewery beerlist-style beerlist-rating).each { |f| expire_fragment(f) }

    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: "Beer was successfully created." }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1 or /beers/1.json
  def update
    %w(beerlist-name beerlist-brewery beerlist-style beerlist-rating).each { |f| expire_fragment(f) }

    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to beer_url(@beer), notice: "Beer was successfully updated." }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1 or /beers/1.json
  def destroy
    %w(beerlist-name beerlist-brewery beerlist-style beerlist-rating).each { |f| expire_fragment(f) }

    @beer.destroy

    respond_to do |format|
      format.html { redirect_to beers_url, notice: "Beer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beer
    @beer = Beer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def beer_params
    params.require(:beer).permit(:name, :brewery_id, :style_id)
  end
end
