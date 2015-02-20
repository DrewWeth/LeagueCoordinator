class PlayersInCompetitions < ActiveRecord::Base
  include ActiveModel::Dirty

  belongs_to :team
  belongs_to :user
  belongs_to :competition

  validates_uniqueness_of :user_id, :scope => :competition_id




  after_commit :calculate_team_count

  def calculate_team_count
    changes = self.previous_changes["team_id"]
    puts "Changes are: #{changes}"
    if changes != nil
      if changes[0] == nil
        id = changes[1]
        team = Team.find(id)
        count = PlayersInCompetitions.where(:team_id => team.id).count
        if count <= 0
          team.destroy
        else
          team.update(count: count)
        end
      elsif [1] == nil
        id = changes[0]
        team = Team.find(id)
        count = PlayersInCompetitions.where(:team_id => team.id).count
        if count <= 0
          team.destroy
        else
          team.update(count: count)
        end
      else
        changes.each do |c|
          team = Team.find(c)
          count = PlayersInCompetitions.where(:team_id => team.id).count
          if count <= 0
            team.destroy
          else
            team.update(count: count)
          end
        end
      end



    end
  end

end
