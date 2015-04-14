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
    if current_user != nil
      pic = PlayersInCompetitions.where(:competition_id => params[:competition_id], :user_id => current_user.id).take
      if pic == nil
        pic = PlayersInCompetitions.create(:competition_id => params[:competition_id], :user_id => current_user.id)
      end
      if pic.team_id != nil
        team = pic.team
        respond_to do |format|
          format.html { redirect_to :back, alert: 'You are already part of a team. You must leave <a href="'+ team_url(team) +'">'+ team.name+'</a>'}
        end
      else
        @team = Team.new
      end
    else
      redirect_to new_user_session_path
    end
  end

  # GET /teams/1/edit
  def edit
    if !can_edit?
      redirect_to root, notice: "You cannot edit this page"
    end
    @players = get_members(@team.competition_id, @team.id)
  end

  # POST /teams
  # POST /teams.json
  def create
    enforce_login
    @team = Team.new(team_params)
    @team.competition_id = params[:competition_id]
    @team.user_id = current_user.id
    respond_to do |format|
      if @team.save

        @pic = PlayersInCompetitions.where(:competition_id => @team.competition_id).where(:user_id => current_user.id).take

        if @pic == nil
          @pic = PlayersInCompetitions.new
          @pic.competition_id = @team.competition.id
          @pic.user_id = current_user.id
        end

        @pic.team_id = @team.id
        @pic.save


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
        format.html { redirect_to new_user_session_path, notice: 'Please login to join this team. Thank you!' }
        format.json { render :show, status: :created, location: new_user_session_path }
      end
    else
      @team = Team.find(params["id"])
      @pic = PlayersInCompetitions.where(:competition_id => @team.competition_id).where(:user_id => current_user.id).take

      if @pic == nil
        @pic = PlayersInCompetitions.new
        @pic.competition_id = @team.competition.id
        @pic.user_id = current_user.id
      end

      can_save = true

      if @pic.team_id == nil # Not on a team
        @pic.team_id = params["id"]
      else
        if @pic.team_id == @team.id
          can_save = false
        else
          @pic.team_id = params["id"]
          @pic.save
        end
      end



      respond_to do |format|
        if can_save and @pic.save
          format.html { redirect_to @team, notice: 'You joined this team. Good luck!' }
          format.json { render :show, status: :created, location: @competition }
        elsif !can_save
          format.html { redirect_to @team, alert: "You're already on this team" }
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
      user = params["user_id"] || current_user.id
      @pic = PlayersInCompetitions.where(:competition_id => @team.competition_id).where(:user_id => current_user.id).take
      @pic.team_id = nil

      @team.count -= 1
      competition = @team.competition

      respond_to do |format|
        if @pic.save
          if @team.count <= 0
            format.html { redirect_to competition, notice: 'You successfully left this team.' }
            format.json { render :show, status: :created, location: @team }
          else
            format.html { redirect_to @team, notice: 'You successfully left this team.' }
            format.json { render :show, status: :created, location: @team }
          end

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
    if can_edit?
      respond_to do |format|
        if @team.update(team_params)
          format.html { redirect_to @team, notice: 'Team was successfully updated.' }
          format.json { render :show, status: :ok, location: @team }
        else
          format.html { render :edit }
          format.json { render json: @team.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to :back, alert: "You cannot do that."
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    if can_edit?
      @team.destroy
      respond_to do |format|
        format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to :back, alert: "You cannot do that."
    end
  end

  private
    def get_members(comp, team)
      PlayersInCompetitions.where(:competition_id => comp, :team_id => team).map{|x| x.user}
    end

    def enforce_login
      if current_user == nil
        redirect_to new_user_session_path
      end
    end

    def can_edit?
      enforce_login
      if @team.user_id == current_user.id
        return true
      elsif @team.competition.user_id == current_user.id
        return true
      else
        return false
      end
    end

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
