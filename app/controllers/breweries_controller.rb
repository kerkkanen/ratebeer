class BreweriesController < ApplicationController
  before_action :set_brewery, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  # before_action :expire_cache, only: %i[create update destroy toggle_activity]

  # GET /breweries or /breweries.json
  def index
    @breweries = Brewery.all
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
  end

  # GET /breweries/1 or /breweries/1.json
  def show
  end

  def list
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
    @brewery_listing = brewery_listing
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries or /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)
    @brewery_listing = brewery_listing

    respond_to do |format|
      if @brewery.save
        status = @brewery.active? ? "active" : "retired"
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("#{status}_brewery_rows", partial: "brewery_row", locals: { brewery: @brewery }),
            turbo_stream.replace("#{status}_count", partial: "list_headers", locals: { status:, count: status == "active" ? Brewery.active.count : Brewery.retired.count })
          ]
        end
        format.html { redirect_to brewery_url(@brewery), notice: "Brewery was successfully created." }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new, status: :unprocessable_entity, locals: { brewery_listing: } }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1 or /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to brewery_url(@brewery), notice: "Brewery was successfully updated." }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1 or /breweries/1.json
  def destroy
    status = @brewery.active? ? "active" : "retired"
    @breweries = status == "active" ? Brewery.active : Brewery.retired

    respond_to do |format|
      if @brewery.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("brewery_#{@brewery.id}"),
            turbo_stream.replace("#{status}_count", partial: "list_headers", locals: { status:, count: status == "active" ? Brewery.active.count : Brewery.retired.count })
          ]
        end
        format.html { redirect_to breweries_url, notice: "Brewery was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, !brewery.active

    new_status = brewery.active? ? "active" : "retired"

    redirect_to brewery, notice: "brewery activity status changed to #{new_status}"
  end

  def active
    # simulate a delay in calculating the recommendation
    sleep(2)
    status = "active"
    @breweries = Brewery.active
    render partial: 'brewery_list', locals: { breweries: @breweries, status: }
  end

  def retired
    status = "retired"
    @breweries = Brewery.retired
    render partial: 'brewery_list', locals: { breweries: @breweries, status: }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brewery
    @brewery = Brewery.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def brewery_params
    params.require(:brewery).permit(:name, :year, :active)
  end

  def expire_cache
    expire_fragment('brewerylist')
  end

  def brewery_listing
    breweries_api = BreweriesApi.new
    breweries_api.list_breweries
  end
end
