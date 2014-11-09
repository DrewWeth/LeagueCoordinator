class Team < ActiveRecord::Base
  has_many :players_in_competitions
  belongs_to :competition
end
