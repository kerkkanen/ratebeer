class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.includes(:ratings).all
  end

  # GET /users/1 or /users/1.json
  def show
    @ratings = @user.ratings
    memberships = Membership.where(user_id: params[:id], confirmed: true).map{ |m| m.beer_club.id }
    @clubs = memberships.each.map{ |m| BeerClub.where(id: m) }
    if current_user
      applied = Membership.where(user_id: current_user.id, confirmed: false).map{ |m| m.beer_club.id }
      @applications = applied.map{ |m| BeerClub.where id: m }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if user_params[:username].nil? && (@user == current_user) && @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    user = User.find(params[:id])
    user.destroy if current_user == user
    session.destroy
    redirect_to users_path
  end

  def toggle_activity
    user = User.find(params[:id])
    user.update_attribute :active, !user.active

    new_status = user.active? ? "active" : "closed"

    redirect_to user, notice: "user's activity status changed to #{new_status}"
  end

  def recommendation
    # simulate a delay in calculating the recommendation
    sleep(2)
    ids = Beer.pluck(:id)
    # our recommendation us just a randomly picked beer...
    random_beer = Beer.find(ids.sample)
    render partial: 'recommendation', locals: { beer: random_beer }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :active)
  end
end
