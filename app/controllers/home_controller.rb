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

  # POST
  def distribute
    message = params["message"]
    comp_id = params["competition"].to_i
    comp = Competition.find(comp_id)

    if comp.user_id == current_user.id

      require 'twilio-ruby'

  		account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
  		auth_token = '77d93608f97102a6011bb3fd90229a85'

  		begin
  			@client = Twilio::REST::Client.new account_sid, auth_token
  		rescue Twilio::RESR::RequestError => e
  			puts e.message
  		end



      participants = PlayersInCompetitions.where(:competition_id => comp_id)
      targets = participants.map{|x| User.find(x.user_id).phone }

      targets.each do |number|
        @client.account.messages.create(
			         :from => '+13147363270',
			         :to => number,
			         :body =>  message)
      end

      flash[:notice] = message + " sent to: " + targets.join(', ')
    end
    redirect_to comp
  end

end
