#
class Api::V1::ReservationsController < ApiController
  before_action :authenticate_user!, only: [:index]
  before_action :find_reservation!, only: %i[show update destroy]

  def create
    @train = Train.find_by_number!(params[:train_number])
    @reservation = Reservation.new(train_id: @train.id,
                                   seat_number: params[:seat_number],
                                   customer_name: params[:customer_name],
                                   customer_phone: params[:customer_phone])
    @reservation.user = current_user
    if @reservation.save
      render json: {
        booking_code: @reservation.booking_code,
        reservation_url: api_v1_reservation_url(@reservation.booking_code)
      }
    else
      render json: { message: '订票失败', errors: @reservation.errors },
             status: 400
    end
  end

  def show
    render json: {
      booking_code: @reservation.booking_code,
      train_number: @reservation.train.number,
      seat_number: @reservation.seat_number,
      customer_name: @reservation.customer_name,
      customer_phone: @reservation.customer_phone
    }
  end

  def index
    @reservations = current_user.reservations
    render json: {
      data: @reservations.map do |reservation|
        {
          booking_code: reservation.booking_code,
          train_number: reservation.train.number,
          seat_number: reservation.seat_number,
          customer_name: reservation.customer_name,
          customer_phone: reservation.customer_phone
        }
      end
    }
  end

  def update
    @reservation.update(reservation_params)
    render json: { message: '更新成功' }
  end

  def destroy
    @reservation.destroy
    render json: {
      message: '已取消定位'
    }
  end

  protected

  def find_reservation!
    @reservation = Reservation.find_by_booking_code!(params[:booking_code])
  end

  def reservation_params
    params.permit(:customer_name, :customer_phone)
  end
end
