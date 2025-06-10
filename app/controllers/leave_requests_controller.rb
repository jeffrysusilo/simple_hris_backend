class LeaveRequestsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin, only: [:approve, :reject]

  # GET /leave_requests
  def index
    if @current_user.role == 'admin'
      leave_requests = LeaveRequest.includes(:user).order(created_at: :desc)
    else
      leave_requests = @current_user.leave_requests.order(created_at: :desc)
    end

    render json: leave_requests.as_json(include: :user)
  end

  # POST /leave_requests
  def create
    leave = @current_user.leave_requests.new(leave_params)
    leave.status = 'pending'

    if leave.save
      render json: { message: "Pengajuan cuti dikirim", data: leave }, status: :created
    else
      render json: { errors: leave.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /leave_requests/:id/approve
  def approve
    leave = LeaveRequest.find(params[:id])
    leave.update(status: 'approved')

    render json: { message: "Cuti disetujui", data: leave }
  end

  # PATCH /leave_requests/:id/reject
  def reject
    leave = LeaveRequest.find(params[:id])
    leave.update(status: 'rejected')

    render json: { message: "Cuti ditolak", data: leave }
  end

  private

  def leave_params
    params.require(:leave_request).permit(:start_date, :end_date, :reason)
  end
end
