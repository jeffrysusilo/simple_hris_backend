class DashboardController < ApplicationController
  before_action :authorize_request
  before_action :authorize_admin

  def summary
    total_users = User.where(role: 'employee').count
    total_leaves = LeaveRequest.count
    approved = LeaveRequest.where(status: 'approved').count
    pending = LeaveRequest.where(status: 'pending').count
    rejected = LeaveRequest.where(status: 'rejected').count

    render json: {
      total_users: total_users,
      leave_requests: {
        total: total_leaves,
        approved: approved,
        pending: pending,
        rejected: rejected
      }
    }
  end
end
