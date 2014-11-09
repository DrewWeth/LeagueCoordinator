class User < ActiveRecord::Base
  has_many :players_in_competitions
  has_many :competitions, :through => :players_in_competitions

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
