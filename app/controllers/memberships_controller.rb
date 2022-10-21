class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    member = Membership.where(user_id: current_user.id).map(&:beer_club_id)
    clubs = []
    BeerClub.all.each do |club|
      if member.exclude?(club.id)
        clubs << club
      end
    end
    @beer_clubs = clubs
  end

  # GET /memberships/1/edit
  def edit
    @beer_clubs = BeerClub.all
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.create params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user
    @membership.confirmed = false

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_url(@membership.beer_club_id), notice: "#{current_user.username}, welcome to the club! Wait for membership confirmation." }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    club = BeerClub.where(id: @membership.beer_club_id)
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to user_url(current_user), notice: "Membership in #{club[0].name} ended" }
      format.json { head :no_content }
    end
  end

  def accept()
    membership = Membership.find(params[:id])
    membership.confirmed = true
    membership.save
    redirect_to beer_club_url
    
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:id, :user_id, :beer_club_id, :confirmed)
  end
end
