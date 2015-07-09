module Api::V1
  class AppLogsController < ApiController
    #doorkeeper_for :index
    #doorkeeper_for :create, :scopes => [:write]
    
    before_action :doorkeeper_authorize!, only: [:index, :create]

    respond_to :json

    def index
      respond_with AppLog.recent
    end

    def create
      app_log = AppLog.new(profile_params)
      if app_log.save
        render json: app_log 
      else
        render :json => { :errors => app_log.errors.full_messages }  
      end
    end

    private

    def profile_params
      params.require(:app_log).permit(:account_id, :status, :message, :used_space, :used_memory, :app_name)
    end
  end
end