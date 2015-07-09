class Api::V1::FastController < ActionController::Metal
  include AbstractController::Callbacks
  include ActionController::Head
  #include Doorkeeper::Helpers::Filter

  #doorkeeper_for :all
  before_action :doorkeeper_authorize!

  def index
    self.response_body = { :ok => true }.to_json
  end
end
