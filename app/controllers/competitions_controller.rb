class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]

  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.all
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
    @teams = @competition.teams.order('name')
    is_member?

    @freelancers = PlayersInCompetitions.where(:competition_id => @competition.id).where(:team_id => nil)

    @all_players = PlayersInCompetitions.where(:competition_id => @competition.id)

  end

  # GET /competitions/new
  def new
    enforce_login
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
    if !is_owner?
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'You are not the owner of this competition.' }
        format.json { render :show, status: :created, location: new_user_session_path }
      end
    end

  end

  def join
    if current_user == nil
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'Please login so we have some data to organize your game with. Thank you!' }
        format.json { render :show, status: :created, location: new_user_session_path }
      end
    else
      @competition = Competition.find(params["id"])

      @pic = PlayersInCompetitions.new
      @pic.competition_id = params["id"]
      @pic.user_id = current_user.id


      respond_to do |format|
        if @pic.save
          format.html { redirect_to @competition, notice: 'You successfully joined this competition.' }
          format.json { render :show, status: :created, location: @competition }
        else
          format.html { render :new }
          format.json { render json: @competition.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /players in competitions/1
  # DELETE /competitions/1.json
  def leave
    enforce_login
    @competition = Competition.find(params["id"])
    @pic = PlayersInCompetitions.where(:competition_id => params["id"]).where(:user_id => current_user.id).take

    respond_to do |format|
      if @pic != nil and @pic.destroy
        format.html { redirect_to @competition, notice: 'You left the competition.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @competition, notice: 'Something went wrong. Failed to leave competition.' }
        format.json { head :no_content }
      end
    end
  end


  # POST /competitions
  # POST /competitions.json
  def create
    enforce_login
    @competition = Competition.new(competition_params)
    @competition.active = true

    respond_to do |format|
      if @competition.save
        format.html { redirect_to @competition, notice: 'Competition was successfully created.' }
        format.json { render :show, status: :created, location: @competition }
      else
        format.html { render :new }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to @competition, notice: 'Competition was successfully updated.' }
        format.json { render :show, status: :ok, location: @competition }
      else
        format.html { render :edit }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    @competition.destroy
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: 'Competition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def is_member?
      @is_member = false

      if current_user != nil and pic = PlayersInCompetitions.where(:competition_id => @competition.id).where(:user_id => current_user.id).take
        @is_member = true
        @users_association = pic
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    def is_owner?
      @is_owner = false
      if current_user != nil and @competition.user_id == current_user.id
        @is_owner = true

      end
    end

    def enforce_login
      if current_user == nil
        redirect_to new_user_session_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:competition).permit(:name, :description, :at, :active, :user_id)
    end
end
