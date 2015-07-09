class User
  include Mongoid::Document
  include Mongoid::Timestamps
  extend DeviseOverrides
  include NumberGenerator
  rolify

  attr_accessor :stripe_token, :coupon
  
  belongs_to :account, inverse_of: :users, class_name: Account.name
  has_one :profile, inverse_of: :user
  
  before_validation { self.account ||= Account.current }
  scope :by_account, -> { where(account: Account.current ) }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :confirmed_at,       type: Time
  field :confirmation_sent_at, type: Time
  field :confirmation_token, type: String
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :authentication_token, type: String
  field :number, as: :key, type: String
  field :unconfirmed_email, type: String

  ## Stripe
  field :customer_id, type: String
  field :last_4_digits, type: String

  before_save :ensure_authentication_token
  # before_save :update_stripe
  validates_uniqueness_of :authentication_token
  
  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  # accepts_nested_attributes_for :account
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def update_stripe
    # return if email.include?(ENV['ADMIN_EMAIL'])
    # return if email.include?('@example.com') and not Rails.env.production?
    if customer_id.nil?
      if stripe_token.nil?
        raise "Stripe token not present. Can't create account."
      end
      customer = Stripe::Customer.create(
          :email => email,
          :description => "",
          :card => stripe_token,
          :plan => roles.first.name
      )
    else
      customer = Stripe::Customer.retrieve(customer_id)
      if stripe_token.present?
        customer.card = stripe_token
      end
      customer.email = email
      customer.description = email
      customer.save
    end
    self.last_4_digits = customer.sources.data.first["last4"]
    self.customer_id = customer.id
    self.stripe_token = nil
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "#{e.message}."
    self.stripe_token = nil
    false
  end
  
end
