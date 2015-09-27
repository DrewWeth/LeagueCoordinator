class User < ActiveRecord::Base
  has_many :players_in_competitions, dependent: :destroy
  has_many :competitions, :through => :players_in_competitions
  has_many :teams
  has_many :competitions

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_length_of :summoner_name, :maximum => 50

  validates :f_name, presence: true, length: { maximum: 25 }
  validates :l_name, presence: true, length: { maximum: 25 }
  validates :summoner_name, length: { maximum: 30 }
  validates :phone, length: { maximum: 15 }


end
