class HomeController < ApplicationController

  def index
    if current_user != nil
      redirect_to competitions_path
    else
      render 'home/index'
    end
  end


  def about
  end

  def help
  end

end
