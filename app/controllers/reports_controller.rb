class ReportsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin

  # GET /reports/attendances
  def attendances
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Attendance.minimum(:date)
    end_date   = params[:end_date].present? ? Date.parse(params[:end_date]) : Attendance.maximum(:date)

    attendances = Attendance.includes(:user).where(date: start_date..end_date)

    data = attendances.map do |a|
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

    summary = calculate_summary(attendances, start_date, end_date)

    render json: {
      summary: summary,
      data: data
    }
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

  def calculate_summary(attendances, start_date, end_date)
    total_hadir = attendances.count { |a| a.check_in.present? }
    terlambat = attendances.count { |a| a.check_in.present? && a.check_in > a.date.to_time.change(hour: 9, min: 0) }
    tanpa_checkout = attendances.count { |a| a.check_in.present? && a.check_out.nil? }

    all_employee_ids = User.where(role: 'employee').pluck(:id)
    total_days = (start_date..end_date).to_a

    absents = 0
    all_employee_ids.each do |user_id|
      user_days = attendances.select { |a| a.user_id == user_id }.map(&:date)
      absents += (total_days - user_days).count
    end

    {
      hadir: total_hadir,
      terlambat: terlambat,
      tanpa_checkout: tanpa_checkout,
      tidak_hadir: absents
    }
  end

end
