require 'rails_helper'

RSpec.describe TokenGeneratorService do
  let(:user) { create(:user) }
  let(:service) { TokenGeneratorService.new(user) }
  
  describe '#generate_token' do
    it 'generates a valid JWT token' do
      token = service.generate_token
      
      # Verifica que el token sea una cadena no vacía
      expect(token).to be_a(String)
      expect(token).not_to be_empty
      
      # Decodifica el token y verifica que contenga la información correcta
      decoded = TokenGeneratorService.decode(token)
      expect(decoded).not_to be_nil
      expect(decoded[:user_id]).to eq(user.id)
      expect(decoded[:exp]).to be > Time.now.to_i
    end
    
    it 'accepts a custom expiration time' do
      expiration = 1.hour.from_now
      token = service.generate_token(expiration)
      
      decoded = TokenGeneratorService.decode(token)
      expect(decoded[:exp]).to be_within(1).of(expiration.to_i)
    end
  end
  
  describe '.decode' do
    it 'decodes a valid token' do
      token = service.generate_token
      decoded = TokenGeneratorService.decode(token)
      
      expect(decoded).to be_a(HashWithIndifferentAccess)
      expect(decoded[:user_id]).to eq(user.id)
    end
    
    it 'returns nil for an invalid token' do
      expect(TokenGeneratorService.decode('invalid.token')).to be_nil
    end
    
    it 'returns nil for an expired token' do
      # Generar token que expira inmediatamente
      expiration = 1.second.ago
      token = service.generate_token(expiration)
      
      # Esperar un momento para asegurar que expire
      sleep(1)
      
      # Decodificar token expirado
      expect(TokenGeneratorService.decode(token)).to be_nil
    end
  end
end
