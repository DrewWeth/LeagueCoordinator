class Competition < ActiveRecord::Base
  include ActiveModel::Dirty

  before_destroy :destroy_players_in_competitions

  has_many :players_in_competitions
  has_many :users, :through => :players_in_competitions
  has_many :teams, dependent: :destroy

  validates :name, presence: true, length: { maximum: 25 }
  validates :at, presence: true
  validates :location, presence: true, length: { maximum: 100 }
  validates :user_id, :presence => true

  validates_length_of :description, :maximum => 300, :message=>"Description can only be 300 characters."

  belongs_to :user

  geocoded_by :location
  after_validation :geocode

  private

  def destroy_players_in_competitions
    PlayersInCompetitions.where(:competition_id => self.id).destroy_all
  end

end
