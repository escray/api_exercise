require 'rails_helper'

RSpec.describe 'API_V1::Reservations', type: :request do
  before do
    @train1 = Train.create!(number: '0822')
    @train2 = Train.create!(number: '0603')

    @user = User.create!(email: 'test@example.com', password: '12345678')
    @reservation = Reservation.create!(
      train_id: @train1.id, seat_number: '1A',
      customer_name: 'foo', customer_phone: '12345678'
    )
  end

  example 'GET /api/v1/reservations/{booking_code}' do
    get "/api/v1/reservations/#{@reservation.booking_code}"

    expect(response).to have_http_status(200)
    expect(response.body).to eq({
      booking_code: @reservation.booking_code,
      train_number: @reservation.train.number,
      seat_number: @reservation.seat_number,
      customer_name: @reservation.customer_name,
      customer_phone: @reservation.customer_phone
    }.to_json)
  end

  example 'DELETE /api/v1/reservations/{booking_code}' do
    delete "/api/v1/reservations/#{@reservation.booking_code}"
    expect(response).to have_http_status(200)
    expect(response.body).to eq({ message: '已取消定位' }.to_json)
    expect(Reservation.count).to eq(0)
  end

  example 'PATCH /api/v1/reservations/{booking_code}' do
    patch "/api/v1/reservations/#{@reservation.booking_code}", params: {
      customer_name: 'bar',
      customer_phone: '987654321'
    }
    expect(response).to have_http_status(200)
    expect(response.body).to eq({ message: '更新成功' }.to_json)
    @reservation.reload
    expect(@reservation.customer_name).to eq('bar')
    expect(@reservation.customer_phone).to eq('987654321')
  end
end
