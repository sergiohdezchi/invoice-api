require 'rails_helper'

RSpec.describe JwtService do
  let(:service) { described_class.new }
  let(:payload) { { invoice_id: 1, total: 10 } }
  let(:client_id) { API_CLIENTS.keys.first }
  let(:api_key) { API_CLIENTS[client_id] }

  before do
    stub_const("JwtService::API_CLIENTS", {
      'client1' => 'secret1',
      'client2' => 'secret2'
    }.with_indifferent_access)
  end

  describe '#encode' do
    it 'decodes payload correctly' do
      token = service.encode(payload)
      decoded = service.decode(token)

      expect(decoded[:invoice_id]).to eq(payload[:invoice_id])
      expect(decoded[:total]).to eq(payload[:total])
      expect(decoded).to have_key(:exp)
    end

    it 'sets expiration time correctly' do
      exp_time = 2.hours.from_now
      token = service.encode(payload, exp_time)
      decoded = service.decode(token)

      expect(decoded[:exp]).to eq(exp_time.to_i)
    end
  end

  describe '#decode' do
    it 'returns nil for invalid token' do
      expect(service.decode('invalid.token')).to be_nil
    end

    it 'returns nil for expired token' do
      token = JWT.encode({ exp: 1.minute.ago.to_i }, JwtService::SECRET_KEY)
      expect(service.decode(token)).to be_nil
    end
  end

  describe '#generate_token' do
    it 'returns a token for valid client credentials' do
      token = service.generate_token('client1', 'secret1')
      expect(token).not_to be_nil

      decoded = service.decode(token)
      expect(decoded[:client_id]).to eq('client1')
      expect(decoded[:authorized]).to eq(true)
    end

    it 'returns nil for invalid client_id' do
      expect(service.generate_token('invalid_client', 'secret1')).to be_nil
    end

    it 'returns nil for invalid api_key' do
      expect(service.generate_token('client1', 'wrong_secret')).to be_nil
    end
  end

  describe '#authorized_client?' do
    it 'returns true for a valid client token' do
      token = service.generate_token('client1', 'secret1')
      expect(service.authorized_client?(token)).to be true
    end

    it 'returns false for an invalid token' do
      expect(service.authorized_client?('invalid.token')).to be false
    end

    it 'returns false for a token with non-existent client_id' do
      token = service.encode({ client_id: 'non_existent', authorized: true })
      expect(service.authorized_client?(token)).to be false
    end

    it 'returns false for a token without authorized flag' do
      token = service.encode({ client_id: 'client1' })
      expect(service.authorized_client?(token)).to be false
    end
  end
end
