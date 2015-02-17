class Team < ActiveRecord::Base
  validates :name, presence: true
  has_many :players_in_competitions
  belongs_to :competition
  belongs_to :user

  before_destroy :cleanup

  def cleanup
    team_id = self.id
    PlayersInCompetitions.where(:team_id => team_id).update_all(:team_id => nil)
  end

end
