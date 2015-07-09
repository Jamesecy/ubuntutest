module Api::V1
  class ProfilesController < ApiController
    #doorkeeper_for :index
    #doorkeeper_for :create, :scopes => [:write]
    
    before_action :doorkeeper_authorize!, only: [:index, :create]

    respond_to :json

    def index
      respond_with Profile.all
    end

    def create
      profile = Profile.create!(profile_params)
      respond_to do |format|
        msg = { :status => "ok", :message => "Success!" }
        format.json { render :json => msg } 
      end
    end

    private

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :username)
    end
  end
end
