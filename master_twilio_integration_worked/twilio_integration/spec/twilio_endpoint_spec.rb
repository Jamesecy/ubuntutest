require 'spec_helper'

describe TwilioEndpoint do
  let(:config)  { { 'twilio_account_sid' => 'ABC', 'twilio_auth_token' => 'ABC' } }

  let(:customer_phone) { '+55321' }
  let(:alt_phone)      { '+5512341234' }
  let(:client)         { double('Twilio client').as_null_object }

  before do
    Twilio::REST::Client.stub(:new).with('ABC', 'ABC').and_return(client)
  end

  context 'when SMS' do
    let(:sms) do
      { message: 'Howdy!', phone: customer_phone, from: alt_phone }
    end

    let(:request) { { request_id: '1234567',
                      sms: sms,
                      parameters: config } }

    describe '/send_sms' do
      it 'sends a SMS' do
        expect(client).to receive(:create).
          with(from: alt_phone,
               to: customer_phone,
               body: 'Howdy!')

          post '/send_sms', request.to_json, auth

          expect(last_response).to be_ok
          expect(json_response[:summary]).to eq %{SMS "Howdy!" sent to #{customer_phone}}
      end

      context 'something went wrong!' do
        it 'returns the exception in the summary key' do
          expect(client).to receive(:create).and_raise StandardError.new "Booom!"

          post '/send_sms', request.to_json, auth

          expect(last_response.status).to eq 500
          expect(json_response[:summary]).to eq "Booom!"
        end
      end
    end
  end
end
