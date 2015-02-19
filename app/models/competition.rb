class Competition < ActiveRecord::Base
  has_many :players_in_competitions, dependent: :destroy
  has_many :users, :through => :players_in_competitions
  has_many :teams, dependent: :destroy

  validates :name, presence: true
  validates :at, presence: true
  validates :location, presence: true

  belongs_to :user

  validates_length_of :name, :minimum => 3, :maximum => 25, :allow_blank => false
  validates_length_of :description, :maximum => 300, :allow_blank => true
  validates_length_of :location, :maximum => 100, :allow_blank => false

end
