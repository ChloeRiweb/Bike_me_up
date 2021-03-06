class BookingsController < ApplicationController
  # skip_after_action :verify_authorized, only: [:index]
  def index
    @bookings = policy_scope(Booking)
  end

  def new
    @bike = Bike.find(params[:bike_id])
    @booking = Booking.new
    authorize @booking
  end

  def show
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def create
    @bike = Bike.find(params[:bike_id])
    @booking = Booking.new(booking_params)
    @booking.bike = @bike
    nb_days = (@booking.end_date - @booking.start_date).to_i
    @booking.total_price = nb_days * @bike.price
    authorize @booking
    @booking.user = current_user
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bike_path(@booking.bike)
  end


  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :total_price)
  end

  def find_booking
    @booking = booking.find(params[:id])
  end
end
