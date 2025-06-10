class AttendancesController < ApplicationController
  before_action :authorize_request

  # POST /attendances/checkin
  def checkin
    today = Date.today

    # Cegah double check-in
    existing = @current_user.attendances.find_by(date: today)
    if existing
      return render json: { error: "Kamu sudah check-in hari ini" }, status: :unprocessable_entity
    end

    attendance = @current_user.attendances.create(
      check_in: Time.current,
      date: today
    )

    if attendance.persisted?
      render json: { message: "Berhasil check-in", data: attendance }, status: :created
    else
      render json: { error: attendance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /attendances/checkout
  def checkout
    today = Date.today
    attendance = @current_user.attendances.find_by(date: today)

    unless attendance
      return render json: { error: "Belum check-in hari ini" }, status: :not_found
    end

    if attendance.check_out
      return render json: { error: "Sudah check-out sebelumnya" }, status: :unprocessable_entity
    end

    attendance.update(check_out: Time.current)
    render json: { message: "Berhasil check-out", data: attendance }
  end

  # GET /attendances
  def index
    render json: @current_user.attendances.order(date: :desc)
  end
end

