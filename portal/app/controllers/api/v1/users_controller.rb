module Api::V1
  class UsersController < ApiController
    #doorkeeper_for :index
    #doorkeeper_for :create, :scopes => [:write]
    
    before_action :doorkeeper_authorize!, only: [:index, :create]

    respond_to :json

    def index
      respond_with User.all
    end

    def create
      respond_with 'api_v1', User.create!(params[:user])
    end
  end
end
