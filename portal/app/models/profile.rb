class Profile
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :username, type: String
  
  belongs_to :user, inverse_of: :profile
end
