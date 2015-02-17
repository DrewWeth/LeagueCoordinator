class Competition < ActiveRecord::Base
  has_many :players_in_competitions, dependent: :destroy
  has_many :users, :through => :players_in_competitions
  has_many :teams, dependent: :destroy
  validates :name, presence: true
  belongs_to :user

end
