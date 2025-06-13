class ReportsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin

  # GET /reports/attendances
  def attendances
    attendances = Attendance.all

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      attendances = attendances.where(date: start_date..end_date)
    end

    data = attendances.includes(:user).map do |a|
      {
        id: a.id,
        name: a.user.name,
        email: a.user.email,
        date: a.date,
        check_in: a.check_in&.strftime("%H:%M"),
        check_out: a.check_out&.strftime("%H:%M"),
        status: attendance_status(a)
      }
    end

    render json: data
  end

  private

  def attendance_status(attendance)
    if attendance.check_in.nil?
      "Belum Hadir"
    elsif attendance.check_in > Time.parse("09:00")
      "Terlambat"
    else
      "Tepat Waktu"
    end
  end
end
