# This code is a test case written using the RSpec testing framework for a Books API in a Ruby on Rails application.
require 'rails_helper'

describe 'Authentication APIs', type: :request do

  describe 'POST /authentication' do
    let(:user) { FactoryBot.build(:user, email: 'admin@example.com', password: 'password', password_confirmation: 'password') }

    it 'authenticates the client' do
      user.save
      post '/api/v1/auth/login/', params: { email: 'admin@example.com', password: 'password' }, headers: { 'HTTP_ACCEPT' => 'application/json', 'Authorization' => nil}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).not_to be_nil
      expect(JSON.parse(response.body)['token']).to eq(JsonWebToken.encode(user_id: user.id))
    end

    it 'returns error when email is missing' do
      post '/api/v1/auth/login', params: { password: 'password' }, headers: { 'HTTP_ACCEPT' => 'application/json', 'Authorization' => nil}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('param is missing or the value is empty: email')
    end

    it 'returns error when password is missing' do
      post '/api/v1/auth/login', params: { email: 'admin@example.com' }, headers: { 'HTTP_ACCEPT' => 'application/json', 'Authorization' => nil}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('param is missing or the value is empty: password')
    end
  end
end
