class AppLog
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :account, inverse_of: :app_log
  scope :recent, -> { limit(5).order_by([:updated_at, :asc]) }
  
  STATUS_VALUES = [:operational, :down].freeze
 
  field :status, type: String, default: ""
  field :app_name, type: String, default: ""
  field :used_space, type: BigDecimal, default: 0
  field :used_memory, type: BigDecimal, default: 0
  field :message, type: String, default: ""

  class << self
    def status_enum
      STATUS_VALUES
    end
  end

end
