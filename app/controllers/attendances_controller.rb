class AttendancesController < ApplicationController
  before_action :authorize_request

  # POST /attendances/checkin
  def checkin
    today = Date.today

    existing = @current_user.attendances.find_by(date: today)
    if existing
      return render json: { error: "Kamu sudah check-in hari ini" }, status: :unprocessable_entity
    end

    attendance = @current_user.attendances.create(
      check_in: Time.current,
      date: today
    )

    if attendance.persisted?
      render json: { 
        message: "Berhasil check-in", 
        data: format_attendance(attendance) 
      }, status: :created
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
    render json: { 
      message: "Berhasil check-out", 
      data: format_attendance(attendance) 
    }
  end

  # GET /attendances
  def index
    attendances = @current_user.attendances.order(date: :desc)
    render json: attendances.map { |a| format_attendance(a) }
  end

  private

  def format_attendance(att)
    {
      id: att.id,
      date: att.date,
      check_in: att.check_in&.strftime("%H:%M"),
      check_out: att.check_out&.strftime("%H:%M")
    }
  end
end
