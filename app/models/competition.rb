class Competition < ActiveRecord::Base
  has_many :players_in_competitions
  has_many :users, :through => :players_in_competitions
  has_many :teams
end
