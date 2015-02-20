class PlayersInCompetitions < ActiveRecord::Base
  include ActiveModel::Dirty

  belongs_to :team
  belongs_to :user
  belongs_to :competition

  validates_uniqueness_of :user_id, :scope => :competition_id




  after_commit :calculate_team_count

  def calculate_team_count
    changes = self.previous_changes["team_id"]
    if changes != nil
      if changes[0] == nil
        id = changes[1]
        team = Team.find(id)
        count = PlayersInCompetitions.where(:team_id => team.id).count
        team.update(count: count)


      else

        id = changes[0]
        team = Team.find(id)
        count = PlayersInCompetitions.where(:team_id => team.id).count
        team.update(count: count)
        

      end
    end
  end

end
