require 'rails_helper'

RSpec.describe 'API_V1::Auth', type: :request do
  example 'register' do
    post '/api/v1/signup', params: {
      email: 'test2@example.com',
      password: '12345678'
    }
    expect(response).to have_http_status(200)

    new_user = User.last
    expect(new_user.email).to eq('test2@example.com')

    expect(response.body).to eq({ user_id: new_user.id }.to_json)
  end

  example 'register failed' do
    post '/api/v1/signup', params: { email: 'test2@example.com' }
    expect(response).to have_http_status(400)
    expect(response.body).to eq({ :message => 'Failed',
                                  :errors => {
                                  :password => ["can't be blank"]
                                }}.to_json)
  end

  before do
    @user = User.created!(email: 'test@example.com', password: '12345678')
  end
end
