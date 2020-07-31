class V1::BookingSlotsController < ::V1::ApplicationController
  before_action :authenticate_request
  before_action :set_booking_slot, only: [:update,:destroy]
  before_action :available_slot, only: [:create,:update]

 def create
   if @errors.empty?
    
    @booking_slot = BookingSlot.new(booking_slot_params)
    @booking_slot.user_id = @current_user.id
    if @booking_slot.save
        render json:@booking_slot
          else
        render json: @booking_slot.errors, status: :unprocessable_entity
    end
  else
    render json:@errors
  end
  end

  def update
  if @booking_slot.user_id == @current_user.id
      if @errors.empty? 
      @booking_slot.update(booking_slot_params)
        render json: (@booking_slot)
      else
        render json: @errors, status: :unprocessable_entity
      end
  else
    render json: {message:"You do not access to update the booking slot"}
    end
  end

  def destroy
  
      if @booking_slot.user_id == @current_user.id
      @booking_slot.destroy
      render json: {message:"The Booking Slot has been deleted"}
      else
      render json: {message:"You do not access to delete the booking slot"}
      end
  end
  private

  def set_booking_slot
    @booking_slot = BookingSlot.find(params[:id])
  end

  def available_slot
    @errors = {}
    if params[:date].nil? || params[:date].empty?
    @errors[:date] = "Booking date is required"
    else
      date = DateTime.parse(params[:date])
    end
    if params[:from_time].nil? || params[:from_time].empty?
      @errors[:from_time] ="staring time of the booking slot is required"
    else
      from_time = DateTime.parse(params[:from_time])   
    end
    if params[:to_time].nil? || params[:to_time].empty?
      @errors[:to_time] ="end time of the booking slot is required"
    else
    to_time = DateTime.parse(params[:to_time])
    end
  @bookings = BookingSlot.where("date=? and from_time >= ? and to_time <= ?",date,from_time,to_time)  
  if @bookings.present? 
     @errors[:error] = "The Booking Slot has been booked for the date" 
    end
  
end

  def booking_slot_params
    params.permit(:date,:from_time,:to_time,:user_id,:name)
  end
end