class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @members = PlayersInCompetitions.where(:competition_id => @team.competition_id).where(:team_id => @team.id)
    if current_user != nil
      @is_member = @members.map( &:user_id).include? current_user.id
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    @team.competition_id = params[:competition_id]
    @team.user_id = current_user.id

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end


  def upmate
    if current_user == nil
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'Please login so we have some data to organize your game with. Thank you!' }
        format.json { render :show, status: :created, location: new_user_session_path }
      end
    else
      @team = Team.find(params["id"])
      @pic = PlayersInCompetitions.where(:competition_id => @team.competition_id).where(:user_id => current_user.id).take

      if @pic.team_id != nil
        old_team = @pic.team
        old_team.count -= 1
        old_team.save
      end

      @pic.team_id = params["id"]
      @team.count += 1

      respond_to do |format|
        if @pic.save
          @team.save
          format.html { redirect_to @team, notice: 'You joined this team. Good luck!' }
          format.json { render :show, status: :created, location: @competition }
        else
          format.html { render :new }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /players in competitions/1
  # DELETE /competitions/1.json
  def downmate
    if current_user == nil
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'Please login so we have some data to organize your game with. Thank you!' }
        format.json { render :show, status: :created, location: new_user_session_path }
      end
    else

      @team = Team.find(params["id"])
      @pic = PlayersInCompetitions.where(:competition_id => @team.competition_id).where(:user_id => current_user.id).take
      @pic.team_id = nil
      @team.count -= 1

      respond_to do |format|
        if @pic.save
          @team.save
          format.html { redirect_to @team, notice: 'You successfully left this team.' }
          format.json { render :show, status: :created, location: @team }
        else
          format.html { render :new }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    end
  end



  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def is_member?
      @is_member = false

      if (pic = PlayersInCompetitions.where(:competition_id => @competition.id).where(:user_id => current_user.id).where(:team_id => @team.id).take)
        @is_member = true
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :active, :user_id, :competition_id)
    end
end
