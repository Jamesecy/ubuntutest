class Message
  def initialize(config, message_text, phone_number, from)
    #@client = Twilio::REST::Client.new('ACa1549f8be7f30d1802bea446495bd728', '48461649510250e474d81886c3ea1afa')
    @client = Twilio::REST::Client.new(config['twilio_account_sid'], config['twilio_auth_token'])
    @message_text = message_text
    @phone_number = phone_number
    @from = from
  end

  def deliver
    @client.account.messages.create(
      from:   @from,
      to:     @phone_number,
      body:   @message_text
    )
  end
end
