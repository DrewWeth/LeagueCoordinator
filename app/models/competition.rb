class Competition < ActiveRecord::Base
  has_many :players_in_competitions, dependent: :destroy
  has_many :users, :through => :players_in_competitions
  has_many :teams, dependent: :destroy

  validates :name, presence: true, length: { maximum: 25 }
  validates :at, presence: true
  validates :location, presence: true, length: { maximum: 100 }
  validates :user_id, :presence => true

  validates_length_of :description, :maximum => 300, :message=>"Description can only be 300 characters."

  belongs_to :user




end
