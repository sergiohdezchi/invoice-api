require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  describe 'POST #register' do
    let(:valid_params) do
      {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        name: 'Test User'
      }
    end
    
    let(:invalid_params) do
      {
        email: 'invalid-email',
        password: '123',
        password_confirmation: '456'
      }
    end
    
    it 'creates a new user with valid parameters' do
      expect {
        post :register, params: valid_params
      }.to change(User, :count).by(1)
      
      expect(response).to have_http_status(:created)
      
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('success')
      expect(json_response['data']['user']).to include('email' => 'test@example.com')
      expect(json_response['data']['token']).to be_present
      expect(json_response['data']['expires_at']).to be_present
    end
    
    it 'fails to create user with invalid parameters' do
      expect {
        post :register, params: invalid_params
      }.not_to change(User, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
      
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('error')
      expect(json_response['errors']).to be_present
    end
  end
  
  describe 'POST #login' do
    let!(:user) { create(:user, email: 'login@example.com', password: 'password123') }
    
    it 'returns a token when credentials are valid' do
      post :login, params: { email: 'login@example.com', password: 'password123' }
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('success')
      expect(json_response['data']['token']).to be_present
      expect(json_response['data']['user']).to include('id' => user.id)
    end
    
    it 'returns unauthorized when credentials are invalid' do
      post :login, params: { email: 'login@example.com', password: 'wrong_password' }
      
      expect(response).to have_http_status(:unauthorized)
      
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('error')
      expect(json_response['message']).to include('inválidas')
    end
  end
end
