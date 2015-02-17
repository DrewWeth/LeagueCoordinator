class CompetitionsController < ApplicationController

  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.where("at >= ?", DateTime.now.at_beginning_of_day.utc).order("at")
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
    @competition.at = DateTime.now
  end

  # GET /competitions/1/edit
  def edit
    @teams = Team.where(:competition_id => @competition.id)
    if !is_owner?


      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'You are not the owner of this competition.' }
        format.json { render :show, status: :created, location: new_user_session_path }
      end
    end
  end

  def search
    @results = Competition.where("name like :kw or description like :kw", :kw=>"%#{params[:query]}%").all

    @data = ""
    @results.each do |r|
        @data += "<a class='list-group-item' href='" + url_for(r) + "'>"
        @data += r.name + "<span class='pull-right'>" + r.at.to_s +  "</span></a>"

    end


    render :html => @data.html_safe
  end

  def join
    if current_user == nil
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'Please login. Thank you!' }
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
    @pic = PlayersInCompetitions.where(:competition_id => params["id"]).where(:user_id => current_user.id).take

    if @pic.team_id != nil
      @team = @pic.team
      @team.count -= 1
      @team.save
    end

    respond_to do |format|
      if @pic != nil and @pic.destroy
        format.html { redirect_to @pic.competition, notice: 'You left the competition.' }
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
    # puts "DATETIME-------------------------------------- >> " << Time.strptime(params[:datetime], "%m/%d/%Y %H:%M %p").to_s
    @competition.user_id = current_user.id
    @competition.at = Time.strptime(params[:datetime] + " UTC", "%m/%d/%Y %H:%M %p %Z") # Hella hacky

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
      params.require(:competition).permit(:name, :description, :at, :active, :user_id, :image, :location)
    end
end
